module ApplicationHelper

  def gly_icon(icon, text = "")
    raw(content_tag(:span, text, class: "glyphicon glyphicon-#{icon}") + " ")
  end

  def nav_li_class cn
    controller_name ==  cn ? 'active' : ''
  end
end
