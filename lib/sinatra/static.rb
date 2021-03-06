require 'sinatra/base'

module Sinatra
  module Static
    module Helpers
      def favicon_link_tag(source = :favicon,
                           rel: 'shortcut icon',
                           type: 'image/x-icon')
        %(<link rel="#{rel}"
                href="#{Private.static_url(self, source, 'ico')}"
                type="#{type}" />)
      end

      def preconnect_link_tag(source)
        %(<link rel="preconnect"
                href="#{source}"
                crossorigin />)
      end

      def stylesheet_link_tag(*sources, media: 'screen')
        sources.map { |source|
          %(<link rel="stylesheet"
                  href="#{Private.static_url(self, source, 'css')}"
                  media="#{media}" />)
        }.join("\n")
      end

      def javascript_include_tag(*sources, crossorigin: :anonymous)
        sources.map { |source|
          %(<script src="#{Private.static_url(self, source, 'js')}"
                    crossorigin="#{crossorigin}"></script>)
        }.join("\n")
      end

      def google_fonts(*fonts)
        families = fonts.map { |font| "family=#{font}" }.join('&')
        source = "https://fonts.googleapis.com/css2?#{families}&display=swap"
        <<~HTML
          #{preconnect_link_tag('https://fonts.gstatic.com')}
          #{stylesheet_link_tag(source)}
        HTML
      end

      def font_awesome(kit_id)
        javascript_include_tag("https://kit.fontawesome.com/#{kit_id}.js",
                               crossorigin: :anonymous)
      end
    end

    module Private
      @mtimes = {}
      class << self
        private

        def time(app, source)
          return Time.now.to_i if app.class.development?

          unless @mtimes.key?(source)
            @mtimes[source] = File.mtime(static_path(app, source)).to_i
          end

          return @mtimes.fetch(source)
        end

        def static_path(app, source)
          return File.join(app.settings.public_folder, source)
        end
      end

      def self.static_url(app, source, ext = nil)
        source = source.to_s
        return source if source.start_with?('http')

        source.prepend('/') unless source.start_with?('/')
        source += ".#{ext}" if ext && File.extname(source).empty?
        return "#{source}?v=#{time(app, source)}"
      end
    end

    def self.registered(app)
      app.helpers(Static::Helpers)

      app.set(:static_cache_control,
              [:public, :immutable, { max_age: 31536000 }])
    end
  end

  register Static
end
