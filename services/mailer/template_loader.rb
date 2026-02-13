require_relative "../../lib/app_logger"

module Services
  module Mailer
    class TemplateLoader
      TEMPLATE_DIR = "templates/email"

      def initialize
        @cache = {}
      end

      def load(template_name)
        if @cache.key?(template_name)
          AppLogger.info("Loading template from cache: #{template_name}")
          return @cache[template_name]
        end

        path = File.join(TEMPLATE_DIR, "#{template_name}.html.erb")
        unless File.exist?(path)
          AppLogger.warn("Template not found: #{path}")
          raise "Missing template: #{template_name}"
        end

        AppLogger.info("Loading template from disk: #{path}")
        content = File.read(path)
        @cache[template_name] = content
        content
      end

      def preload(template_names)
        template_names.each do |name|
          load(name)
        rescue StandardError => e
          AppLogger.warn("Failed to preload template #{name}: #{e.message}")
        end
      end

      def clear_cache
        AppLogger.info("Clearing template cache (#{@cache.size} entries)")
        @cache.clear
      end
    end
  end
end
