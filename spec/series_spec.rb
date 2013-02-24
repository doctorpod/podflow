require 'podflow/yamlable'
require 'podflow/upload'
require 'podflow/view'
require 'podflow/inform'
require 'podflow/series'
require 'helpers'

module Podflow
  describe Series do
    it "should dump a YAML series file" do
      data = {'name' => 'Underpants', 'artist' => 'Ned Kelly'}
      puts Series.new(data).to_yaml.should == File.read(samples('series_config.yml'))
    end
    
    describe "loading a YAML series_config file" do
      before(:each) do
        yaml_string = File.read(samples('series_config.yml'))
        @series = Series.load(yaml_string)
      end
      
      it "should be a Series" do
        @series.class.should == Series
      end
      
      it "should have correct name" do
        @series.name.should == 'Underpants'
      end
      
      it "should have correct artist" do
        @series.artist.should == 'Ned Kelly'
      end
      
      it "should convert back to original YAML file" do
        @series.to_yaml.should == File.read(samples('series_config.yml'))
      end
    end
  end
end
