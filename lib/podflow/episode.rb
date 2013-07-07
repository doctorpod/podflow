module Podflow
  class Episode
    CONFIG_SEARCH_PATHS = ['episodes', '.']
    MEDIA_SEARCH_PATHS = ['media', 'mp3', '.']
    attr_reader :number, :name, :comments, :year, :images, :subtitle, :pubdate,
                :explicit, :keywords, :config_path
  
    def initialize(data = {}, config_path = nil)
      load_data(data)
      @config_path = config_path
    end
    
    def load_data(data)
      @number = data['number'] || data['track'] || 0
      @name = data['name'] || 'MyEpisode'
      @comments = data['comments'] ? data['comments'].chomp : 'MyComments'
      @year = data['year'] || Time.now.year
      @images = data['images'] ? to_objects(Image, data['images']) : [Image.new]
      @subtitle = data['subtitle'] ? data['subtitle'].chomp : 'MySubtitle'
      @pubdate = data['pubdate'] || Time.now.strftime("%Y/%m/%d %H:%M")
      @explicit = data['explicit'] || false
      @keywords = data['keywords'] || ['MyKeyword']
    end
    
    def media_path
      PodUtils::find_file!("#{File.basename(config_path, '.yml')}.mp3", MEDIA_SEARCH_PATHS)
    end
    
    def read_tags(path = media_path)
      STDOUT.puts "Episode: reading tags from media #{path}"
      values = TagMP3.read_tags(path)
      load_data(values.inject({}) {|stringified, (k,v)| stringified[k.to_s] = v; stringified})
    end
    
    def data_hash
      {:track => number,
       :name => name,
       :album => 'TODO',
       :comments => comments,
       :year => year}
    end
    
    def write_tags(path = media_path)
      STDOUT.puts "Episode: writing tags to media #{path}"
      values = TagMP3.write_tags(path, data_hash)
    end
    
    def self.generate_config_file(episode_name, number)
      episode = new

      if episode_name
        @number = number || episode_name.to_i

        if matching_mp3 = PodUtils.find_file("#{episode_name}.mp3", MEDIA_SEARCH_PATHS)
          read_tags(matching_mp3)
        end

        PodUtils.write_unless_exists(episode.to_yaml, episode_name + '.yml', CONFIG_SEARCH_PATHS)
      else
        if greatest_mp3 = find_highest('mp3', MEDIA_SEARCH_PATHS)
          read_tags(greatest_mp3)
          PodUtils.write_unless_exists(to_yaml, File.basename(greatest_mp3, '.mp3') + '.yml', CONFIG_SEARCH_PATHS)
        else
          STDERR.puts "ERROR: Must specify an episode name as no MP3 files found from which to derive one"
          exit
        end
      end
    end
    
    def upload
      puts "Pretending to upload - TODO"
    end
    
    def inform
      puts "Preteding to inform - TODO"
    end
    
    def self.find_highest(ext, paths)
      paths.each do |path|
        search_glob = File.join(path, "*.#{ext}")
        found = Dir.glob(search_glob)
        return found.sort.last if found.any?
      end

      nil
    end
    
    def self.find_highest!(ext, paths)
      found = find_highest(ext, paths)

      if found.nil?
        STDERR.puts "ERROR: Cannot find any episodes in #{paths.join(', ')}"
        exit
      else
        found
      end
    end
    
    def self.highest_or_matching(name)
      path = name.nil? ? find_highest!(:yml, CONFIG_SEARCH_PATHS) : PodUtils::find_file!("#{name}.yml", CONFIG_SEARCH_PATHS)
      new(YAML.load(path), path)
    end
  end
end
