module ApplicationHelper
  def render_title(base, extra, join_string: " - ")
    value = [base, extra].reject(&:blank?).join(join_string) 
    content_tag(:title, value)
  end

  def render_join(collection, join_string, &block)
    output = collection.map { |*args| capture(*args, &block) }
    safe_join(output, join_string)
  end

  def with_layout(name, namespace, &block)
    render(layout: name, locals: namespace, &block)
  end
  
  def with_public_layout(strip_collection: nil, strip: nil, &block)
    namespace = case
    when strip_collection
      {title: strip_collection.name, favicon: strip_collection.icon_url}
    when strip
      {title: strip.title, favicon: strip.strip_collection.icon_url}
    else
      {title: nil, favicon: nil}
    end
    with_layout("layouts/public", namespace, &block)  
  end
end
