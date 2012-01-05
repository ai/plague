namespace :posts do
  task :check_cache => :environment do
    cache = Rails.application.config.action_controller.page_cache_directory
    last = Post.last_published

    posts = File.join(cache, 'posts.html')
    unless File.exists? posts
      FileUtils.rm_rf cache
    else
      all = File.read(posts)
      unless all.include? last.url
        FileUtils.rm_rf cache
      end
    end
  end
end
