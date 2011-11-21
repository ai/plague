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

  def for_hero?
    comment_for == 'hero'
  end

  def for_author?
    comment_for == 'author'
  end

  def fictional?
    answer.try(:from_hero?) or for_hero?
  end

  def real_life?
    answer.try(:from_author?) or for_author?
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

  def html
    self.text.split("\n").inject(''.html_safe) do |html, i|
      html + '<p>'.html_safe + i + '</p>'.html_safe
    end
  end
end
