module ApplicationHelper

  def uk_icon(icon)
    raw(content_tag(:i, "", class: "uk-icon-#{icon}") + " ")
  end

end
