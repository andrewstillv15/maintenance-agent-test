require "logger"

module Services
  module Mailer
    class TemplateLoader
      TEMPLATE_DIR = "templates/email"

      def initialize
        @logger = Logger.new(STDOUT)
        @cache = {}
      end

      def load(template_name)
        if @cache.key?(template_name)
          @logger.info("Loading template from cache: #{template_name}")
          return @cache[template_name]
        end

        path = File.join(TEMPLATE_DIR, "#{template_name}.html.erb")
        unless File.exist?(path)
          @logger.warn("Template not found: #{path}")
          raise "Missing template: #{template_name}"
        end

        @logger.info("Loading template from disk: #{path}")
        content = File.read(path)
        @cache[template_name] = content
        content
      end

      def preload(template_names)
        template_names.each do |name|
          load(name)
        rescue StandardError => e
          @logger.warn("Failed to preload template #{name}: #{e.message}")
        end
      end

      def clear_cache
        @logger.info("Clearing template cache (#{@cache.size} entries)")
        @cache.clear
      end
    end
  end
end
