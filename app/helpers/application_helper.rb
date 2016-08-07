module ApplicationHelper

  def gly_icon(icon, text = "")
    raw(content_tag(:span, text, class: "glyphicon glyphicon-#{icon}") + " ")
  end

end
