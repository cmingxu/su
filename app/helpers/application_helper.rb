module ApplicationHelper

  def uk_icon(icon)
    raw(content_tag(:i, "", class: "uk-icon-#{icon}") + " ")
  end

  def user_signed_in?
    true
  end
end
