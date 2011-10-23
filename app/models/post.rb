class Post
  class NotFound < StandardError; end

  URLS = { hero: 'say-and-relax.com/hero' }

  def self.story_root
    Pathname(Rails.configuration.story['story_repo'])
  end

  def self.by_url(url)
    story = URLS.find { |i, prefix| url.start_with? prefix }
    raise NotFound unless story
    story = story.first.to_s

    name = url.match  /\/([^\/]+)\/?$/
    raise NotFound unless name
    name = name[1]

    Dir.glob(story_root.join(story, '*.md')) do |file|
      post = Post.new(story, File.basename(file, '.md'))
      return post if post.name == name
    end

    raise NotFound
  end

  attr_reader :path, :source_code

  def initialize(path, file = nil)
    path += '/' + file if file
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

  def [](name)
    attrs[name]
  end

  def title
    attrs['title']
  end

  def name
    attrs['name']
  end

  def html
    compile unless @compiled
    @html
  end

  private

  def compile
    @compiled = true
    text = @source_code
    @attrs = {}
    if text.lines.first =~ /^[\w-]+: /
      before, text = text.split("\n\n", 2)
      @attrs = YAML.load(before)
    end
    @html = Kramdown::Document.new(text).to_html.html_safe
  end
end
