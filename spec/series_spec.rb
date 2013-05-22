require 'podflow/commands/series_command'
require 'helpers'
require 'yaml'

class FakeUpload
  def initialize(data = {})
  end
end

class FakeView
  def initialize(data = {})
  end

  def render(bind, working_folder, stderr)
    "fake view"
  end
end

class FakeInform
  def initialize(data = {})
  end
end

module Podflow
  module Commands
    describe SeriesCommand do
      before(:each) do
        @stderr = double('Stderr').as_null_object
        data = YAML.load_file(samples('series_config.yml'))
        @series = Series.new(data, FakeUpload, FakeView, FakeInform)
      end
    
      describe "rendering views" do
        it "should render views" do
          @series.render_views(binding, sandbox, @stderr, false).should == "fake view"
        end
      
      
        describe "interactive option" do
          it "should prompt before each view" do
            pending "Decide how to design testable interactiveness"
          end
        end
      end
    end
  end
end
