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
  field :important,    type: Boolean
  field :moderated,    type: Boolean
  include Mongoid::Timestamps

  embeds_one :answer

  validates :post_path, exists_post: true
  validates :text,      presence: true

  def self.important
    where(important: true)
  end

  def self.unimportant
    excludes(important: true)
  end

  def self.published
    excludes(published_at: nil)
  end

  def self.unmoderated
    where(moderated: nil)
  end

  def self.recent
    asc(:published_at)
  end

  def fictional?
    answer.try(:answer_from) == 'hero' or comment_for == 'hero'
  end

  def real_life?
    answer.try(:answer_from) == 'author' or comment_for == 'author'
  end

  def author_name
    name = super
    name.present? ? name : 'Аноним'
  end

  def post
    @post ||= Post.by_path(self.post_path)
  end

  def publish!
    self.published_at = Time.now
    self.moderated    = true
    self.save!
  end
end
