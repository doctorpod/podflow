require 'podflow/series'
require 'helpers'

module Podflow
  describe Series do
    describe "new instance" do
      it "should render YAML" do
        Series.new.to_yaml.should == File.read(samples('series_config.yml'))
      end
    end
    
    describe "from saved file" do
      it "should render correct object" do
        loaded = Series.load(samples('series_config.yml'))
        loaded.artist.should == 'MyArtist'
        loaded.uploads[0].name.should == 'MyName'
      end
    end
  end
end
