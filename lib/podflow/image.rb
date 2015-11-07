module Podflow
  class Image
    MEDIA_SEARCH_PATHS = ['images', 'img']
    attr_reader :file, :alt

    def initialize(data = {})
      @file = data['file'] || 'MyFile'
      @alt = data['alt'] ? data['alt'].chomp : 'MyAlt'
    end

    def path
      PodUtils.find_file!(file, MEDIA_SEARCH_PATHS)
    end
  end
end
