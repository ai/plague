# encoding: utf-8
class Post
  class NotFound < StandardError; end

  Link = Struct.new(:href, :title, :description) do
    def wiki?
      href.start_with? 'wiki:'
    end

    def wiki_page
      href.sub(/^wiki:/, '')
    end
  end

  class Wiki
    def self.wikipedia
      "Википедия #{(Date.today + 17.years).year} года"
    end

    attr_reader :name, :title, :text, :html

    def initialize(name, text)
      @name  = name
      @text  = text
      @html  = Kramdown::Document.new(text).to_html.html_safe
      @title = @text.match(/\*\*([^\*]*)\*\*/)[1]
    end
  end

  cattr_accessor :cache
  cattr_accessor :cached_commit

  def self.story_root
    Rails.root.join(Rails.configuration.story['story_repo'])
  end

  def self.by_file(filepath)
    path = Pathname(filepath).relative_path_from(self.story_root).
      to_s.gsub(/\.md$/, '')
    self.by_path(path)
  end

  def self.story?(story)
    File.exist? self.story_root.join(story, 'title')
  end

  def self.by_url(url)
    story, name = url.gsub('.', '').sub(/^\//, '').split('/', 2)

    raise NotFound unless self.story? story
    raise NotFound unless name

    Dir.glob(self.story_root.join(story, '*.md')) do |file|
      post = self.by_path(story, File.basename(file, '.md'))
      return post if post.name == name
    end

    raise NotFound
  end

  def self.last_commit
    self.story_root.join('.git/refs/heads/master').read.strip
  end

  def self.first_in_story(story)
    raise NotFound unless self.story? story
    self.by_path(story, '01')
  end

  def self.title
    self.by_path('title')
  end

  def self.first
    self.title.next
  end

  def self.last
    post = self.first
    post = post.next while post.next
    post
  end

  def self.last_published
    post = self.first
    post = post.next while post.next and not post.next.draft?
    post
  end

  def self.all
    posts = []
    post   = Post.first
    while post
      posts << post
      post = post.next
    end
    posts
  end

  def self.all_with_important_comments
    posts   = self.all
    entries = posts
    posts.each { |post| entries += post.important_comments.to_a }
    entries.sort { |a, b| a.published_at <=> b.published_at }
  end

  def self.git(command)
    `cd '#{self.story_root}'; git #{command}`
  end

  def self.update_repository!
    git 'pull origin master'
  end

  def self.by_path(path, file = nil)
    path += '/' + file if file
    @@cache[path] ||= self.new(path)
  end

  def self.clear_cache!
    self.cache = {}
    self.cached_commit = self.last_commit
  end

  clear_cache!

  def self.actual_cache?
    self.cached_commit == self.last_commit
  end

  def self.clear_comments_cache!
    self.cache.values.map(&:clear_comments_cache!)
  end

  def self.each(&block)
    post = self.first
    begin
      yield(post)
    end while post = post.next
  end

  attr_reader :path, :source_code

  def initialize(path)
    @path        = path
    @filepath    = self.class.story_root.join(path + '.md')
    raise NotFound unless @filepath.exist?
    @source_code = @filepath.read
  end

  def comments
    Comment.where(post_name: self.name)
  end

  def story_title
    @story_title ||= @filepath.dirname.join('title').read.strip
  end

  def attrs
    compile
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
      return nil unless attrs['published']
      self.published_at.to_date + 17.years
    end
  end

  def links
    compile
    @links
  end

  def wikis
    compile
    @wikis
  end

  def html
    compile
    @html
  end

  def prev
    @prev ||= begin
      return self.class.by_path(attrs['prev']) if attrs['prev']

      posts = story_posts
      current = posts.find_index { |i| i == @filepath }
      return nil if current == 0
      self.class.by_file(posts[current - 1])
    end
  end

  def next
    @next ||= begin
      return self.class.by_path(attrs['next']) if attrs['next']

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
    "/#{self.story_name}/#{self.name}"
  end

  def draft?
    if Rails.env.production?
      self.attrs['published'].nil? or self.published_at > Time.now
    else
      self.attrs['published'].nil?
    end
  end

  def updated_at
    return @updated_at if @updated_at
    time = self.class.git "log -1 --date=iso --pretty=format:%cD #{@filepath}"
    if time.present?
      @updated_at = Time.parse(time).utc
    else
      Time.now.utc
    end
  end

  def published_at
    Time.parse(attrs['published'])
  end

  def comments
    @comments ||= Comment.where(post_path: @path).published.recent
  end

  def important_comments
    @important_comments ||= self.comments.important
  end

  def unimportant_comments
    @unimportant_comments ||= self.comments.unimportant
  end

  def unmoderated_comments
    @unmoderated_comments ||= Comment.where(post_path: @path).unmoderated
  end

  def clear_comments_cache!
    @comments = nil
    @important_comments   = nil
    @unimportant_comments = nil
    @unmoderated_comments = nil
  end

  private

  def story_posts
    @filepath.dirname.children.select { |i| i.to_s.end_with? '.md' }.sort
  end

  def compile
    return if @compiled
    @compiled = true

    text = @source_code

    @attrs = {}
    if text.lines.first =~ /^[\w-]+: /
      before, text = text.split("\n\n", 2)
      @attrs = YAML.load(before)
    end

    @links = []
    text.gsub! /\n*link\n(  [^\n]+\n){2,3}/ do |link|
      link = link.strip.split("\n").map(&:strip)
      @links << Link.new(*link[1..-1])
      ''
    end

    @wikis = {}
    text.gsub! /\n*wiki [^\n]+\n(  [^\n]+\n|\n)*(  [^\n]+|)+/ do |wiki|
      lines = wiki.strip.split("\n")
      wiki_name = lines.first.gsub(/^wiki /, '').strip
      wiki_text = lines[1..-1].map(&:strip).join("\n")
      @wikis[wiki_name] = Wiki.new(wiki_name, wiki_text)
      ''
    end

    @html = Kramdown::Document.new(text).to_html.html_safe
  end
end
