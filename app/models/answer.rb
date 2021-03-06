class Answer
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

  def html
    self.text.split("\n").inject(''.html_safe) do |html, i|
      html + '<p>'.html_safe + i + '</p>'.html_safe
    end
  end
end
