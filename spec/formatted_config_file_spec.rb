require 'podflow/formatted_config_file'
require 'helpers'

module Podflow
  class Bishlet
    attr_accessor :name
  
    def initialize(data = nil)
      @name = data[:name] unless data.nil?
    end
  end

  class Bish < FormattedConfigFile
    has_setting :title, "The Default Title"
    has_children :bishlets, Bishlet
  end

  class Bash < FormattedConfigFile
    has_setting :track, 99
    has_setting :pubdate, "today"
  end

  describe FormattedConfigFile do
    let(:bish) { Bish.new }
    let(:bash) { Bash.new }
  
    it "gets a setting" do
      bish.title.should == "The Default Title"
      bash.track.should == 99
    end
  
    it "sets a setting" do
      bish.title = "Ned Kelly"
      bish.title.should == "Ned Kelly"
    end
  
    it "loads data" do
      bish.load_data({:title => "Gone with the wind", 
                      :bishlets => [
                        {:name => "A bishlet"},
                        {:name => "Another bishlet"}
                      ]})
    
      bash.load_data({track: 42, pubdate: "yesterday"})

      bish.title.should == "Gone with the wind"
      bish.bishlets.size.should == 2
      bish.bishlets.first.class.should == Bishlet
      bish.bishlets.first.name.should == "A bishlet"
      bish.bishlets.last.name.should == "Another bishlet"
      bash.track.should == 42
      bash.pubdate.should == "yesterday"
    end

    it "creates a string based on a template" do
      Bish.new.to_yaml(samples('FormattedConfigFile.erb')).should == "# A comment\ntitle: The Default Title"
    end
  end
end