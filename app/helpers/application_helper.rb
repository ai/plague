module ApplicationHelper

  def class_if(cls, check)
    check ? { class: cls } : { }
  end

end
