require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

if defined? Bundler
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module Plague
  class Application < Rails::Application
    if defined? Uglifier
      config.assets.js_compressor = Uglifier.new(:copyright => false)
    end

    config.encoding = "utf-8"
    config.i18n.default_locale = :ru

    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0'

    config.assets.precompile += %w( quick.css sessions.css error.css
                                    comments_moderation.css
                                    comments_moderation.js )

    config.autoload_paths << "#{config.root}/lib/validators/"

    config.story = YAML.load_file("#{config.root}/config/story.yml")

    config.action_controller.page_cache_directory = Rails.root.
      join('public/cache').to_s
  end
end
