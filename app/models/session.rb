class Session
  include Mongoid::Document

  field :token

  after_create :generate_token!

  def self.author_session
    Session.first || Session.create
  end

  def generate_token!
    self.token = SecureRandom.base64
    self.save!
  end
end
