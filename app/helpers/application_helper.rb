module ApplicationHelper
  def title(base, content_key, join_string: " - ")
    value = [base, content_for(content_key)].compact.join(join_string) 
    content_tag(:title, value)
  end

  def render_join(collection, join_string, &block)
    output = collection.map { |*args| capture(*args, &block) }
    safe_join(output, join_string)
  end

  def with_layout(name, namespace, &block)
    render(layout: name, locals: namespace, &block)
  end
end
