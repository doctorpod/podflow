require 'erb'
require 'podflow/upload'
require 'podflow/view'
require 'podflow/inform'

module Podflow
  class Series
    CONFIG_NAME = 'series_config.yml'
    CONFIG_SEARCH_PATHS = ['config', '.']
    attr_reader :name, :artist, :description, :artwork, :media_uri, :uploads, :views, :informs
  
    def initialize(data = {})
      @name = data['name'] || 'MyName'
      @artist = data['artist'] || 'MyArtist'
      @description = data['description'] || 'MyDescription'
      @artwork = data['artwork'] || 'MyArtwork.jpg'
      @media_uri = data['media_uri'] || 'My.Media/URI/'
      @uploads = to_objects(data['uploads'], Upload)
      @views = to_objects(data['views'], View)
      @informs = to_objects(data['informs'], Inform)
    end
    
    def self.config_path
      PodUtils::find_file!(CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end
    
    def render_views(episode_name)
      series = self
      episode = Episode.highest_or_matching(episode_name)
      views.map { |view| view.render(binding) } .join
    end

    def to_yaml(template_path = 'templates')
      template = ERB.new(get_template_string(template_path), nil, '<>')
      template.result binding
    end
    
    def self.load(path = config_path)
      data_hash = YAML.load(File.read(path))
      new(data_hash)
    end
    
    def self.write
      PodUtils.write_unless_exists(new.to_yaml, CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end

    private
    
    def get_template_string(path)
      File.read(File.expand_path(File.join('..', '..', '..', path, "series.erb"), __FILE__))
    end
    
    def to_objects(arr, klass)
      arr ? arr.map {|e| klass.new(e)} : [klass.new]
    end
  end
end
