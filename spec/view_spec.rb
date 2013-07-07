require 'podflow/view'
require 'helpers'

module Podflow
  describe View do
    before(:each) do
      set_sandbox
      @stderr = double('Stderr').as_null_object
      @view = View.new({'name' => 'My View', 'template' => 'my_template'})
    end
    
    describe "template found" do
      it "renders a view" do
        my_var = 5
        system "mkdir #{sandbox('templates')}"
      
        File.open(sandbox('templates/my_template.erb'), 'w') do |f|
          f.write('4 plus <%= my_var %> is <%= 4 + my_var %>')
        end
      
        @view.render(binding, sandbox, @stderr).should == "\nMy View\n--\n4 plus 5 is 9\n--"
      end
    end
    
    describe "template not found" do
      it "returns failure" do
        @view.render(binding, sandbox, @stderr).should be_false
      end
      
      it "supplies a message" do
        @stderr.should_receive(:puts).with("ERROR: No such template file: #{sandbox('templates/my_template.erb')}")
        @view.render(binding, sandbox, @stderr)
      end
    end
  end
end