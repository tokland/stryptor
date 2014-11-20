module StripsHelper
  def link_to_strip(name, strip, *args)
    if strip
      link_to(name, [strip.strip_collection, strip])
    else
      link_to(name, nil, *args)
    end
  end
  
  def random_path_for_collection_strip(strip)
    random_strip_collection_strips_path(strip.strip_collection)
  end
end
