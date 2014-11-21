module ApplicationHelper
  def title(base, content_key, join_string: " - ")
    value = [base, content_for(content_key)].compact.join(join_string) 
    content_tag(:title, value)
  end
end
