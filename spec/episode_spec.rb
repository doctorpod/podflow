require 'podflow/episode'
require 'helpers'

module Podflow
  describe Episode do
    it "should dump a YAML episode file" do
      Episode.new.to_yaml.blank_times.should == File.read(samples('episode.yml')).blank_times
    end
    
    describe "loading a YAML episode file" do
      before(:each) do
        @episode = Episode.new(YAML.load(File.read(samples('episode.yml'))))
      end
      
      it "should be an Episode" do
        @episode.class.should == Episode
      end
      
      it "should have correct year" do
        @episode.year.should == 1824
      end
      
      it "should have correct pubdate" do
        @episode.pubdate.should == '1824/06/01 12:00'
      end
      
      it "should convert back to original YAML file" do
        @episode.to_yaml.should == File.read(samples('episode.yml'))
      end
    end
  end
end
