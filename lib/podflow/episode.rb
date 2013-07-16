require 'podflow/formatted_config_file'
require 'podflow/pod_utils'
require 'podflow/image'

module Podflow
  class Episode < FormattedConfigFile
    attr_reader :config_path
    
    has_setting :number, 0
    has_setting :name, 'MyEpisode'
    has_setting :comments, 'MyComments'
    has_setting :year, Time.now.year
    has_setting :subtitle, 'MySubtitle'
    has_setting :pubdate, Time.now.strftime("%Y/%m/%d %H:%M")
    has_setting :explicit, false
    has_setting :keywords, ['MyKeyword']
    
    has_children :images, Image
    
    CONFIG_SEARCH_PATHS = ['episodes', '.']
    MEDIA_SEARCH_PATHS = ['media', 'mp3', '.']
    
    def initialize(data = nil, config_path = nil)
      @config_path = config_path
      super(data)
    end
    
    def media_path
      PodUtils::find_file!("#{File.basename(config_path, '.yml')}.mp3", MEDIA_SEARCH_PATHS)
    end
    
    def read_tags(path = media_path)
      load_data(TagMP3.read_tags(path))
      STDOUT.puts "#{path} read"
    end
    
    def series
      @series ||= Series.load
    end
    
    def tag_hash
      {:name => name,
       :album => series.name,
       :artist => series.artist, 
       :comments => comments,
       :genre => series.genre,
       :year => year,
       :track => number,
       :lyrics => comments}
    end
    
    def write_tags(path = nil)
      PodUtils.with_error_handling do
        path ||= media_path
        TagMP3.write_tags(path, tag_hash)
        TagMP3.write_artwork(path, series.artwork_path)
        STDOUT.puts "#{path} tagged"
      end
    end
    
    def self.generate_config_file(episode_name, number)
      episode = new

      if episode_name
        @number = number || episode_name.gsub(/[a-zA-Z]/,'').to_i

        if matching_mp3 = PodUtils.find_file("#{episode_name}.mp3", MEDIA_SEARCH_PATHS)
          read_tags(matching_mp3)
        end

        PodUtils.write_unless_exists(episode.to_yaml, episode_name + '.yml', CONFIG_SEARCH_PATHS)
      else
        if greatest_mp3 = find_highest('mp3', MEDIA_SEARCH_PATHS)
          episode.read_tags(greatest_mp3)
          PodUtils.write_unless_exists(episode.to_yaml, File.basename(greatest_mp3, '.mp3') + '.yml', CONFIG_SEARCH_PATHS)
        else
          raise "Must specify an episode name as no MP3 files found from which to derive one"
        end
      end
    end
    
    def upload
      PodUtils.with_error_handling do
        series.uploads.each {|upload| upload.perform(media_path)}
      end
    end
    
    def upload_images
      PodUtils.with_error_handling do
        series.uploads.each do |upload|
          images.each {|image| upload.perform(image.path)}
        end
      end
    end
    
    def inform
      PodUtils.with_error_handling { series.informs.each {|inform| inform.perform(series, self)} }
    end
    
    def self.find_highest(ext, paths)
      paths.each do |path|
        search_glob = File.join(path, "*.#{ext}")
        found = Dir.glob(search_glob).reject {|path| path =~ Regexp.new(Series::CONFIG_NAME)}
        return found.sort.last if found.any?
      end

      nil
    end
    
    def self.find_highest!(ext, paths)
      found = find_highest(ext, paths)

      if found.nil?
        raise "Cannot find any episodes in #{paths.join(' or ')}"
      else
        found
      end
    end
    
    def self.highest_or_matching(name)
      path = if name.nil?
               find_highest!(:yml, CONFIG_SEARCH_PATHS)
             else
               PodUtils::find_file!("#{name}.yml", CONFIG_SEARCH_PATHS)
             end
             
      new(YAML.load(File.read(path)), path)
    end
  end
end
