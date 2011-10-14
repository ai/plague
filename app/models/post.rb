class Post
  def self.story_root
    Pathname(Rails.configuration.story['story_repo'])
  end

  attr_reader :path, :source_code

  def initialize(path)
    @path = path
    @source_code = self.class.story_root.join(path + '.md').read
  end

  def comments
    Comment.where(post_name: self.name)
  end

  def attrs
    compile unless @compiled
    @attrs
  end

  def html
    compile unless @compiled
    @html
  end

  private

  def compile
    @compiled = true
    text = @source_code
    if text.lines.first =~ /^[\w-]+: /
      before, text = text.split("\n( )*\n", 2)
      @attrs = YAML.load(before)
    end
    @html = Kramdown::Document.new(text).to_html.html_safe
  end
end
