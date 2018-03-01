
class NameMatcher

  #
  # Takes top level managers and makes the interface friendly for a command line.
  #
  module ErrorHandler

    def self.handle_errors
      begin
        yield
      rescue SignalException
        raise
      rescue SystemExit
        raise
      rescue Exception => e
        $stderr.puts(e.message)
        exit 1
      end
    end
  end
  end

