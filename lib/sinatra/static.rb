require 'sinatra/base'

module Sinatra
  module Static
    module Helpers
      def favicon_link_tag(source = 'favicon.ico',
                           rel: 'shortcut icon',
                           type: 'image/x-icon')
        %(<link rel="#{rel}"
                href="#{Private.static_url(self, source)}"
                type="#{type}" />)
      end

      def stylesheet_link_tag(*sources, media: 'screen')
        sources.map { |source|
          source += '.css' if File.extname(source).empty?
          %(<link rel="stylesheet"
                  href="#{Private.static_url(self, source)}"
                  media="#{media}" />)
        }.join("\n")
      end
    end

    module Private
      @mtimes = {}
      class << self
        attr_reader :mtimes
      end

      def self.static_url(app, source)
        source.prepend('/') unless source.start_with?('/')
        path, ext = source.split('.')
        return "#{path}__#{time(app, source)}.#{ext}"
      end

      def self.time(app, source)
        return Time.now.to_i if app.class.development?

        unless mtimes.key?(source)
          mtimes[source] = File.mtime(static_path(app, source)).to_i
        end

        return mtimes.fetch(source)
      end

      def self.static_path(app, source)
        return File.join(app.settings.public_folder, source)
      end
    end

    def self.registered(app)
      app.set(static: false)
      app.helpers(Static::Helpers)

      app.before(/.+?\.(css|js|ico)/) {
        cache_control(:public, :immutable, { max_age: 31536000 })
      }

      app.get(/(.+?)__\d+?\.(css|js|ico)/) { |path, extension|
        send_file(Static::Private.static_path(self, "#{path}.#{extension}"))
      }
    end
  end

  register Static
end
