module StripsHelper
  def random_path_for_collection_strip(strip)
    random_strip_collection_strips_path(strip.strip_collection)
  end
  
  def link_to_history(strip)
    if strip.transcripts.count > 0
      "| ".html_safe + link_to("Historial", "javascript:void(0)",
        :accesskey => "h", :"data-toggle" => "#transcript-history")
    end
  end
  
  def transcribed_today_count 
    user_names = Strip.transcribed_today.map { |s| s.transcripts.first }.map(&:user_name)
    counts = user_names.frequency.sort_by(&:second).reverse
    
    if counts.present?
      msg = counts.map { |username, count| "#{username}: #{count}" }.join(", ")
      "(%s)" % msg
    else
      ""
    end
  end
end
