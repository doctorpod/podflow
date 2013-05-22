require 'podflow/commands/episode_command'
require 'helpers'

module Podflow
  module Commands
    describe EpisodeCommand do
      before(:each) do
        set_sandbox
      end
      
      let(:input) { double('input').as_null_object }
      let(:output) { double('output').as_null_object }
      let(:errput) { double('errput').as_null_object }
      let(:episode_command) { EpisodeCommand.new(sandbox, input, output, errput) }
      let(:episode_name) { '001-foo' }
    
      describe "./episodes folder exists" do
        before(:each) do
          system "mkdir #{sandbox('episodes')}"
        end
      
        describe "no existing episodes file anywhere" do
          before(:each) do
            @status = episode_command.perform([episode_name], FakeEpisode, {})
          end

          it "should return success" do
            @status.should == Command::SUCCESS
          end

          it "should write file in ./episodes" do
            sandbox('episodes', "#{episode_name}.yml").should be_present
          end

          it "should write no file in ." do
            sandbox("#{episode_name}.yml").should_not be_present
          end
        end

        describe "existing episode file in ." do
          before(:each) do
            system "touch #{sandbox("#{episode_name}.yml")}"
          end

          it "should return success" do
            episode_command.perform([episode_name], FakeEpisode, {}).should == Command::SUCCESS
          end

          it "should write file in ./episodes" do
            episode_command.perform([episode_name], FakeEpisode, {})
            sandbox('episodes', "#{episode_name}.yml").should be_present
          end

          it "should warn there is a config file in ." do
            output.should_receive(:puts).with(/^WARNING: .+redundant/)
            episode_command.perform([episode_name], FakeEpisode, {})
          end
        end

        describe "existing episode file in ./episodes" do
          before(:each) do
            system "touch #{sandbox('episodes', "#{episode_name}.yml")}"
            @status = episode_command.perform([episode_name], FakeEpisode, {})
          end

          it "should return failure" do
            @status.should == Command::FAILURE
          end

          it "should not overwrite file in ./episodes" do
            sandbox('episodes', "#{episode_name}.yml").should be_zero_size
          end

          it "should write no file in ." do
            sandbox("#{episode_name}.yml").should_not be_present
          end
        end
      end
    
      describe "./episodes folder absent" do
        describe "no existing episodes file anywhere" do
          before(:each) do
            @status = episode_command.perform([episode_name], FakeEpisode, {})
          end

          it "should return success" do
            @status.should == Command::SUCCESS
          end

          it "should write file in ." do
            sandbox("#{episode_name}.yml").should be_present
          end
        end

        describe "existing episode file in ." do
          before(:each) do
            system "touch #{sandbox("#{episode_name}.yml")}"
          end

          it "should return failure" do
            episode_command.perform([episode_name], FakeEpisode, {}).should == 1
          end

          it "should not overwrite file in ." do
            episode_command.perform([episode_name], FakeEpisode, {})
            sandbox("#{episode_name}.yml").should be_zero_size
          end

          it "should state there is a config file in ." do
            errput.should_receive(:puts).with(/^ERROR: .+exists/)
            episode_command.perform([episode_name], FakeEpisode, {})
          end
        end
      end
    end
  end
end