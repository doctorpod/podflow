require 'podflow/commands/series_command'
require 'helpers'

module Podflow
  module Commands
    describe SeriesCommand do
      before(:each) do
        set_sandbox
      end

      let(:input) { double('input').as_null_object }
      let(:output) { double('output').as_null_object }
      let(:errput) { double('errput').as_null_object }
      let(:series_command) { SeriesCommand.new(sandbox, input, output, errput) }

      describe "./config folder exists" do
        before(:each) do
          system "mkdir #{sandbox('config')}"
        end
        
        describe "no existing config file anywhere" do
          before(:each) do
            @status = series_command.perform(FakeSeries)
          end

          it "should return success" do
            @status.should == Command::SUCCESS
          end
          
          it "should write file in ./config" do
            sandbox('config', 'series_config.yml').should be_present
          end
          
          it "should write no file in ." do
            sandbox('series_config.yml').should_not be_present
          end
        end
        
        describe "existing config file in ." do
          before(:each) do
            system "touch #{sandbox('series_config.yml')}"
          end

          it "should return success" do
            series_command.perform(FakeEpisode).should == Command::SUCCESS
          end
          
          it "should write file in ./config" do
            series_command.perform(FakeEpisode)
            sandbox('config', 'series_config.yml').should be_present
          end
          
          it "should warn there is a config file in ." do
            output.should_receive(:puts).with(/^WARNING: .+redundant/)
            series_command.perform(FakeEpisode)
          end
        end

        describe "existing config file in ./config" do
          before(:each) do
            system "touch #{sandbox('config', 'series_config.yml')}"
            @status = series_command.perform(FakeEpisode)
          end

          it "should return failure" do
            @status.should == Command::FAILURE
          end
          
          it "should not overwrite file in ./config" do
            sandbox('config', 'series_config.yml').should be_zero_size
          end

          it "should write no file in ." do
            sandbox('series_config.yml').should_not be_present
          end
        end
      end
      
      describe "./config folder absent" do
        describe "no existing config file" do
          before(:each) do
            @status = series_command.perform(FakeEpisode)
          end

          it "should return success" do
            @status.should == Command::SUCCESS
          end
          
          it "should write file in ." do
            sandbox('series_config.yml').should be_present
          end
        end
        
        describe "existing config file" do
          before(:each) do
            system "touch #{sandbox('series_config.yml')}"
            @status = series_command.perform(FakeEpisode)
          end

          it "should return failure" do
            @status.should == Command::FAILURE
          end
          
          it "should not overwrite file in ." do
            sandbox('series_config.yml').should be_zero_size
          end
        end
      end
    end
  end
end
