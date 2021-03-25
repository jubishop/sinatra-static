require 'sinatra'

module Sinatra
  module Static
    module Helpers
      @mtimes = {}
      class << self
        attr_reader :mtimes
      end

      def time(asset)
        return Time.now.to_i if self.class.development?

        mtimes = Static::Helpers.mtimes
        unless mtimes.key?(asset)
          mtimes[asset] = File.mtime(static_path(asset)).to_i
        end

        return mtimes.fetch(asset)
      end

      def rel(asset, rel)
        file, ext = *asset.split('.')
        %(<link rel="#{rel}" href="/#{file}__#{time(asset)}.#{ext}" />)
      end

      def css(file)
        rel("#{file}.css", 'stylesheet')
      end

      private

      def static_path(file_name)
        File.join(settings.public_folder, file_name)
      end
    end

    def self.registered(app)
      app.set(static: false)
      app.helpers(Static::Helpers)

      app.before(/.+?\.(css|js|ico)/) {
        cache_control(:public, :immutable, { max_age: 31536000 })
      }

      app.get(%r{/(.+?)__.+?\.(css|js|ico)}) { |file, extension|
        send_file(static_path("#{file}.#{extension}"))
      }
    end
  end
end
