module StripsHelper
  def random_path_for_collection_strip(strip)
    random_strip_collection_strips_path(strip.strip_collection)
  end
  
  def link_to_history(strip)
    tcount = strip.transcripts.count
    if tcount > 0
      link_to "| Historial" % tcount, "javascript:void()",
        :accesskey => "h", :"data-toggle" => "#transcript-history"
    end
  end
end
