module ApplicationHelper

  def class_if(cls, check)
    check ? { class: cls } : { }
  end

  def pl(count, one, few, many)
    form = R18n.get.locale.pluralize(count)
    string = R18n.l(count) + ' '
    if 1 == form
      string + one
    elsif 2 == form
      string + few
    else
      string + many
    end
  end

end
