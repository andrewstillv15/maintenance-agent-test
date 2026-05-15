require "logger"

module AppLogger
  @logger = nil
  @mutex = Mutex.new

  def self.logger
    return @logger if @logger

    @mutex.synchronize do
      return @logger if @logger

      @logger = Logger.new($stdout)
      @logger.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO").upcase)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{msg}\n"
      end
    end
    @logger
  end

  def self.debug(message)
    logger.debug(message)
  end

  def self.info(message)
    logger.info(message)
  end

  def self.warn(message)
    logger.warn(message)
  end

  def self.error(message)
    logger.error(message)
  end

  def self.fatal(message)
    logger.fatal(message)
  end

  # Legacy compatibility - creates a logger instance with a specific name
  def self.create(name)
    logger = Logger.new($stdout)
    logger.progname = name
    logger.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO").upcase)
    logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} [#{progname}] #{msg}\n"
    end
