require 'helpers'

describe "Comands" do
  before do
    set_sandbox
  end
  
  describe "series" do
    it "series_config created" do
      system("cd #{sandbox} && ruby ../bin/podflow series")
      sandbox('series_config.yml').should be_present
    end
  end

  describe "episode" do
    it "yml episode file created" do
      system "touch #{sandbox('flange.mp3')}"
      system("cd #{sandbox} && ruby ../bin/podflow episode")
      sandbox('flange.yml').should be_present
    end
  end
  
  describe "views" do
    it "Correct view displayed" do
      system "cp #{samples('series_config.yml')} #{sandbox}"
      system "cp #{samples('episode.yml')} #{sandbox}"
      system "mkdir #{sandbox('templates')}"
      system "cp #{samples('my_view_template.erb')} #{sandbox('templates')}"
      output = `cd #{sandbox} && ruby ../bin/podflow views episode`
      output.should == <<EOF

MyView
--
series: Underpants, name: MyEpisode, year: 1824
--
EOF
    end
  end
end