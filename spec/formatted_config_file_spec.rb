require 'podflow/formatted_config_file'
require 'helpers'

module Podflow
  class MyClass < FormattedConfigFile
    attr_reader :name
  
    def initialize
      @name = 'Fred'
    end
  end

  describe FormattedConfigFile do
    it "creates a string based on a template" do
      MyClass.new.to_yaml(samples('FormattedConfigFile.erb')).should == "# A comment\nname: Fred"
    end
  end
end