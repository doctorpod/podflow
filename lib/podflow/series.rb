module Podflow
  class Series
    include Yamlable
    attr_reader :name, :artist, :description, :artwork, :media_uri, :uploads, :views, :informs
  
    def initialize(data = {})
      @name = data['name'] || 'MyName'
      @artist = data['artist'] || 'MyArtist'
      @description = data['description'] ? data['description'].chomp : 'MyDescription'
      @artwork = data['artwork'] || 'MyArtwork.jpg'
      @media_uri = data['media_uri'] || 'My.Media/URI/'
      @uploads = data['uploads'] ? to_objects(Upload, data['uploads']) : [Upload.new]
      @views = data['views'] ? to_objects(View, data['views']) : [View.new]
      @informs = data['informs'] ? to_objects(Inform, data['informs']) : [Inform.new]
    end
  end
end
