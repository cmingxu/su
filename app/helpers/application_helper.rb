module ApplicationHelper

  def gly_icon(icon, text = "")
    raw(content_tag(:i, text, class: "glyphicon glyphicon-#{icon} fa-2x") + " ")
  end

  def nav_li_class *cn
    cn.each do |x|
      return 'active' if controller_name ==  x
    end

    return ''
  end
end
