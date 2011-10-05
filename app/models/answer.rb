class Content
  include Mongoid::Document

  field :text
  field :answer_from
  include Mongoid::Timestamps

  embedded_in :comment
end
