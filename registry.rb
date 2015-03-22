module MotiaTools

  def self.logger
    @logger ||= build_default_logger
  end

private

  def self.build_default_logger
    default           = Logger.new(STDOUT)
    default.level     = Logger::INFO
    default.formatter = proc do |severity, datetime, progname, msg|
      case severity
      when 'INFO'   then "#{msg}\n"
      when 'ERROR'  then "\n#{severity}: #{msg}\n"
      else "#{severity}: #{msg}\n"
      end
    end
    default
  end

end
