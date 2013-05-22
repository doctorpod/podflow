require 'podflow/yamlable'

module Podflow
  class Series
    include Yamlable
    attr_reader :name, :artist, :description, :artwork, :media_uri, :uploads, :views, :informs
  
    def initialize(data = {}, upload_factory = Upload, view_factory = View, inform_factory = Inform)
      @name = data['name'] || 'MyName'
      @artist = data['artist'] || 'MyArtist'
      @description = data['description'] ? data['description'].chomp : 'MyDescription'
      @artwork = data['artwork'] || 'MyArtwork.jpg'
      @media_uri = data['media_uri'] || 'My.Media/URI/'
      @uploads = data['uploads'] ? to_objects(upload_factory, data['uploads']) : [upload_factory.new]
      @views = data['views'] ? to_objects(view_factory, data['views']) : [view_factory.new]
      @informs = data['informs'] ? to_objects(inform_factory, data['informs']) : [inform_factory.new]
    end
    
    def render_views(the_binding, working_folder, stderr, interactive)
      views.map { |view| view.render(the_binding, working_folder, stderr) } .join
    end
  end
end
