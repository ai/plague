class Content
  include Mongoid::Document

  field :text
  field :answer_from
  include Mongoid::Timestamps

  embedded_in :comment

  def from_hero?
    answer_from == 'hero'
  end

  def from_author?
    answer_from == 'author'
  end
end
