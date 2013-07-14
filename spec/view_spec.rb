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
        series = 'My series'
        episode = 'My episode'
        template = '<%= series %> : <%= episode %>'
        @view.render(series, episode, template).should == "\nMy View\n--\nMy series : My episode\n--"
      end
    end
  end
end