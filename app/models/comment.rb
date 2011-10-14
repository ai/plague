# encoding: utf-8
class Comment
  include Mongoid::Document

  field :post_path
  field :author_name
  field :author_email
  field :author_ip
  field :text
  field :comment_for
  field :published_at, type: Time
  field :important
  include Mongoid::Timestamps

  embeds_one :answer

  validates :text,    presence: true
  validates :chapter, exists_chapter: true

  def real_life?
    comment_for == 'hero'   and answer.try(:answer_from) == 'hero'
  end

  def fictional?
    comment_for == 'author' and answer.try(:answer_from) == 'author'
  end

  def author_name
    name = super
    name.present? ? name : 'Аноним'
  end
end
