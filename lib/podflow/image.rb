module Podflow
  class Image
    attr_reader :file, :alt
  
    def initialize(data = {})
      @file = data['file'] || 'MyFile'
      @alt = data['alt'] ? data['alt'].chomp : 'MyAlt'
    end
  end
end