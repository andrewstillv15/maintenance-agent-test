require "logger"

module AppLogger
  def self.create(name)
    logger = Logger.new($stdout)
    logger.progname = name
    logger.level = ENV.fetch("LOG_LEVEL", "INFO")
    logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} [#{progname}] #{msg}\n"
    end
    logger
  end
end
