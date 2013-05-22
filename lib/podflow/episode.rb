module Podflow
  class Episode
    include Yamlable
    attr_reader :number, :name, :comments, :year, :images, :subtitle, :pubdate,
                :explicit, :keywords
  
    def initialize(data = {})
      @number = data['number'] || 0
      @name = data['name'] || 'MyEpisode'
      @comments = data['comments'] ? data['comments'].chomp : 'MyComments'
      @year = data['year'] || Time.now.year
      @images = data['images'] ? to_objects(Image, data['images']) : [Image.new]
      @subtitle = data['subtitle'] ? data['subtitle'].chomp : 'MySubtitle'
      @pubdate = data['pubdate'] || Time.now.strftime("%Y/%m/%d %H:%M")
      @explicit = data['explicit'] || false
      @keywords = data['keywords'] || ['MyKeyword']
    end
    
    def read_mp3(path)
      puts "Episode: reading MP3 #{path}"
      self
    end
  end
end
