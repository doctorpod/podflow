require 'helpers'

describe "Tasks" do
  before do
    set_sandbox
    system "mkdir #{sandbox('templates')}"
  end
  
  describe "series tasks" do
    before do
      system("cd #{sandbox} && ruby ../bin/podflow podify")
    end

    it "makes a Rakefile" do
      sandbox('Rakefile').should be_present
    end
    
    it "Makes a config" do
      system("cd #{sandbox} && rake config")
      File.read(sandbox('series_config.yml')).should == File.read(samples('series_config.yml'))
    end
    
    it "Creates an episode file" do
      system("cd #{sandbox} && rake config && rake episode NAME=flange")
      sandbox('flange.yml').should be_present
    end
    
    it "Generates views" do
      system("cd #{sandbox} && rake config && rake episode NAME=flange")
      system "cp #{samples('MyTemplateFile.erb')} #{sandbox('templates')}"
      output = `cd #{sandbox} && rake views`
      output.should == "\nMyView\n--\nseries: MyName, name: MyEpisode, year: 2013\n--\n"
    end
  end
end