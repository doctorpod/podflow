require 'podflow/commands/views_command'
require 'helpers'

module Podflow
  module Commands
    describe ViewsCommand do
      before(:each) do
        set_sandbox
      end
      
      let(:input) { double('input').as_null_object }
      let(:output) { double('output').as_null_object }
      let(:errput) { double('errput').as_null_object }
      let(:series) { double('Series', :render_views => []) }
      let(:series_class) { double('Series Class', :load => series)}
      let(:episode_class) { double('Episode Class', :load => nil) }
      let(:views_command) { ViewsCommand.new(sandbox, input, output, errput) }

      describe "./config folder exists" do
        before do
          system "mkdir #{sandbox('config')}"
          system "cp #{samples('series_config.yml')} #{sandbox}"
          system "touch #{File.join(sandbox, 'foo.yml')}"
        end
        
        it "should render views for episode" do
          series.should_receive(:render_views)
          views_command.perform('foo', {}, series_class, episode_class)
        end
      end
  
      describe "./episodes folder exists" do
      end
  
      describe "missing series_config" do
      end
  
      describe "missing episode" do
      end
  
      describe "no episode specified" do
      end
    end
  end
end
