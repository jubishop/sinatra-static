require 'sinatra/base'

module Sinatra
  module Static
    module Helpers
      def favicon_link_tag(source = 'favicon.ico',
                           rel: 'shortcut icon',
                           type: 'image/x-icon')
        %(<link rel="#{rel}"
                href="#{static_url(source)}"
                type="#{type}" />)
      end

      def stylesheet_link_tag(*sources, media: 'screen')
        sources.map { |source|
          source += '.css' if File.extname(source).empty?
          %(<link rel="stylesheet"
                  href="#{static_url(source)}"
                  media="#{media}" />)
        }.join("\n")
      end

      private

      @mtimes = {}
      class << self
        attr_reader :mtimes
      end

      def time(source)
        return Time.now.to_i if self.class.development?

        mtimes = Static::Helpers.mtimes
        unless mtimes.key?(source)
          mtimes[source] = File.mtime(static_path(source)).to_i
        end

        return mtimes.fetch(source)
      end

      def static_url(source)
        source.prepend('/') unless source.start_with?('/')
        path, ext = source.split('.')
        return "#{path}__#{time(source)}.#{ext}"
      end

      def static_path(source)
        return File.join(settings.public_folder, source)
      end
    end

    def self.registered(app)
      app.set(static: false)
      app.helpers(Static::Helpers)

      app.before(/.+?\.(css|js|ico)/) {
        cache_control(:public, :immutable, { max_age: 31536000 })
      }

      app.get(%r{(.+?)__\d+?\.(css|js|ico)}) { |path, extension|
        send_file(static_path("#{path}.#{extension}"))
      }
    end
  end

  register Static
end
