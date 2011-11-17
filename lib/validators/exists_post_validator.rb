# encoding: utf-8
class ExistsPostValidator < ActiveModel::Validator
  def validate(record)
    begin
      post = Post.by_path(record.post_path)
    rescue Post::NotFound
      record.errors[:post_path] << "не существует"
    end
  end
end
