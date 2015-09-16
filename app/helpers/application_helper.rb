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
      {title: strip_collection.name, favicon: strip_collection.icon_url, image_src: nil}
    when strip
      {title: strip.title, favicon: strip.strip_collection.icon_url, image_src: strip.image.url}
    else
      {title: nil, favicon: nil, image_src: nil}
    end
    with_layout("layouts/public", namespace, &block)  
  end
  
  def signin_path_with_redirect(params = {})
    other_params = request.get? ? {redirect_url: request.fullpath} : params 
    signin_path(params.merge(other_params))
  end

  def javascript_globals
    globals = {env: Rails.env}
    javascript_tag("window.Rails = #{raw(globals.to_json)};")
  end
end
