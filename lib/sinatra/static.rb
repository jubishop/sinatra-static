require 'sinatra'

module Sinatra
  module Static
    module Helpers
      TIME = Time.now.to_i
      private_constant :TIME

      def time
        self.class.development? ? Time.now.to_i : TIME
      end

      def static(asset, rel)
        file, ext = *asset.split('.')
        %(<link rel="#{rel}" href="/#{file}_#{time}.#{ext}" />)
      end

      def css(file)
        static("#{file}.css", 'stylesheet')
      end
    end

    def self.registered(app)
      app.helpers(Static::Helpers)
      app.set(static: false)

      app.before(/.+?\.(css|js|ico)/) {
        cache_control(:public, :immutable, { max_age: 31536000 })
      }

      app.get(%r{/(.+?)_.+?\.(css|js|ico)}) { |file, extension|
        file_name = File.join(Geminabox.public_folder, "#{file}.#{extension}")
        send_file(file_name)
      }
    end
  end
end
