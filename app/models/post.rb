class Post
  class NotFound < StandardError; end

  URLS = { hero: 'say-and-relax.com/hero' }

  def self.story_root
    Rails.root.join(Rails.configuration.story['story_repo'])
  end

  def self.by_file(filepath)
    path = Pathname(filepath).relative_path_from(self.story_root).
      to_s.gsub(/\.md$/, '')
    self.new(path)
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

  def self.update_repository!
    `cd '#{self.story_root}'; git pull origin master`
  end

  attr_reader :path, :source_code

  def initialize(path, file = nil)
    path += '/' + file if file
    @path = path
    @filepath = self.class.story_root.join(path + '.md')
    @source_code = @filepath.read
  end

  def comments
    Comment.where(post_name: self.name)
  end

  def story_title
    @filepath.dirname.join('title').read.strip
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

  def date
    @date ||= begin
      return nil unless attrs['date']
      Date.parse(attrs['date'])
    end
  end

  def html
    compile unless @compiled
    @html
  end

  def prev
    @prev ||= begin
      return self.class.new(attrs['prev']) if attrs['prev']

      posts = story_posts
      current = posts.find_index { |i| i == @filepath }
      return nil if current == 0
      self.class.by_file(posts[current - 1])
    end
  end

  def next
    @next ||= begin
      return self.class.new(attrs['next']) if attrs['next']

      posts = story_posts
      current = posts.find_index { |i| i == @filepath }
      return nil if current == posts.length - 1

      post = self.class.by_file(posts[current + 1])
      post.draft? ? nil : post
    end
  end

  def story_name
    File.dirname(@path).to_sym
  end

  def title?
    @path == 'title'
  end

  def url
    return '/' if self.title?
    '/' + URLS[self.story_name] + '/' + self.name
  end

  def draft?
    attrs['draft']
  end

  private

  def story_posts
    @filepath.dirname.children.select { |i| i.to_s.end_with? '.md' }.sort
  end

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
