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

    describe "write a new episode file" do
      before { set_sandbox }

      context "no name supplied" do
        context "existing MP3" do
          before do
            copy_sample_to_sandbox("ding_tagged.mp3")
            in_sandbox { Episode.generate_config_file(nil, nil) }
          end

          it "generates an episode config file" do
            sandbox("ding_tagged.yml").should be_present
          end

          it "config file should have correct tags" do
            data = YAML.load(File.read(sandbox("ding_tagged.yml")))
            data["number"].should == 42
            data["name"].chomp.should == "Ding"
            # data["comments"].chomp.should == "A ding sound"
            data["year"].should == 1962
          end
        end

        context "no existing MP3" do
          it "should raise an error" do
            lambda { in_sandbox { Episode.generate_config_file(nil, nil) } } .should raise_error
          end
        end
      end

      context "name supplied" do
        context "existing matching MP3" do
          before do
            copy_sample_to_sandbox("ding.mp3")
            in_sandbox { Episode.generate_config_file('ding', nil) }
          end

          it "generates an episode config file" do
            sandbox("ding.yml").should be_present
          end
        end

        context "no existing MP3" do
          before do
            in_sandbox { Episode.generate_config_file('ding', nil) }
          end

          it "generates an episode config file" do
            sandbox("ding.yml").should be_present
          end
        end
      end
    end
  end
end
