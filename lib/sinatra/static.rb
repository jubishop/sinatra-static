require 'sinatra'

module Sinatra
  module Static
    module Helpers
      @mtimes = Hash.new

      def time(asset)
        return Time.now.to_i if self.class.development?

        unless @mtimes.key?(asset)
          file_name = File.join(Geminabox.public_folder, "#{file}.#{extension}")
          @mtimes[asset] = File.mtime(file_name).to_i
        end

        return @mtimes.fetch(asset)
      end

      def static(asset, rel)
        file, ext = *asset.split('.')
        %(<link rel="#{rel}" href="/#{file}_#{time(asset)}.#{ext}" />)
      end

      def css(file)
        static("#{file}.css", 'stylesheet')
      end
    end

    def self.registered(app)
      app.set(static: false)
      app.helpers(Static::Helpers)

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
