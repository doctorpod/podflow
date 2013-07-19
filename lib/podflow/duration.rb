module Podflow
  class Duration
    attr_reader :seconds
    
    def initialize(seconds)
      @seconds = seconds
    end
    
    def to_s
      self.seconds.to_s
    end
    
    def human
      @human ||= generate_human
    end
    
    private

    def generate_human
      hrs = mins = 0
      secs = self.seconds

      while secs >= 3600
        secs -= 3600
        hrs += 1
      end

      while secs >= 60
        secs -= 60
        mins += 1
      end

      "#{hrs}:#{"%02d" % mins}:#{"%02d" % secs}"
    end
  end
end