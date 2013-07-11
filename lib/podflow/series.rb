require 'podflow/formatted_config_file'
require 'podflow/upload'
require 'podflow/view'
require 'podflow/inform'
require 'podflow/pod_utils'

module Podflow
  class Series < FormattedConfigFile
    CONFIG_NAME = 'series_config.yml'
    CONFIG_SEARCH_PATHS = ['config', '.']
    attr_reader :name, :artist, :description, :artwork, :media_uri, :uploads, :views, :informs
  
    def initialize(data = {})
      @name = data['name'] || 'MyName'
      @artist = data['artist'] || 'MyArtist'
      @description = data['description'] || 'MyDescription'
      @artwork = data['artwork'] || 'MyArtwork.jpg'
      @media_uri = data['media_uri'] || 'My.Media/URI/'
      @uploads = to_objects(Upload, data['uploads'])
      @views = to_objects(View, data['views'])
      @informs = to_objects(Inform, data['informs'])
    end
    
    def self.config_path
      PodUtils::find_file!(CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end
    
    def render_views(episode_name)
      PodUtils.with_error_handling do
        episode = Episode.highest_or_matching(episode_name)
        views.map { |view| view.render(self, episode) } .join
      end
    end

    def self.load(path = config_path)
      data_hash = YAML.load(File.read(path))
      new(data_hash)
    end
    
    def self.write
      PodUtils.write_unless_exists(new.to_yaml, CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end
  end
end
