require 'podflow/yamlable'

module Podflow
  class MyClass
    include Yamlable
    attr_reader :name
  
    def initialize(data_hash)
      @name = data_hash['name']
    end
  end

  describe Yamlable do
    it "loads from a YAML string" do
      my_obj = MyClass.load('name: Bollo')
      my_obj.name.should == 'Bollo'
    end
  
    it "creates a YAML string" do
      my_obj = MyClass.new({'name' => 'Vince'})
      my_obj.to_yaml('samples').should == 'name: Vince'
    end
  end
end