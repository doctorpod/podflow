module Podflow
  class Size
    attr_reader :bytes
    
    def initialize(bytes)
      @bytes = bytes
    end
    
    def to_s
      self.bytes.to_s
    end
    
    def kb
      @kb ||= self.bytes / 1024.0
    end
    
    def mb
      @mb ||= kb / 1024.0
    end
    
    def gb
      @gb ||= mb / 1024.0
    end
    
    def human
      @human ||= generate_human
    end
    
    private
    
    def generate_human
      if gb > 1
        "#{gb.round}G"
      elsif mb > 1
        "#{mb.round}M"
      elsif kb > 1
        "#{kb.round}K"
      else
        "#{bytes.round}B"
      end
    end
  end
end