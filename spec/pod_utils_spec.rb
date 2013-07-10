require 'helpers'
require 'podflow/pod_utils'

module Podflow
  describe PodUtils do
    let(:path1) { sandbox("foo") }
    let(:path2) { sandbox("bar") }
    let(:file) { "my_file.txt" }
      
    before do
      set_sandbox
      Dir.mkdir(path1)
      Dir.mkdir(path2)
    end
    
    describe "find_file" do
      before { File.open(File.join(path1, file), "w") {|f| f.write("")} }
      
      it "Returns path if found" do
        PodUtils.find_file(file, [path1,path2]).should == File.join(path1, file)
      end
      
      it "Returns nil if not found" do
        PodUtils.find_file("flange.txt", [path1,path2]).should be_nil
      end
    end
    
    describe "write_unless_exists" do
      context "File does not exist in any path" do
        before do
          @res = PodUtils.write_unless_exists("hello", file, [path1,path2])
        end
        
        it "should write the file in first path" do
          File.join(path1, file).should be_present
        end
        
        it "Should return true" do
          @res.should be_true
        end
      end
      
      context "File exists in first path" do
        before do
          File.open(File.join(path1, file), "w") {|f| f.write("")}
          @res = PodUtils.write_unless_exists("hello", file, [path1,path2])
        end
        
        it "Should return false" do
          @res.should be_false
        end
      end
      
      context "File exists in last path" do
        before do
          File.open(File.join(path2, file), "w") {|f| f.write("")}
        end
        
        it "It should write the file in first path" do
          PodUtils.write_unless_exists("hello", file, [path1,path2])
          File.join(path1, file).should be_present
        end
        
        it "Should warn of redundent file in last path" do
          out = double("stdout").as_null_object
          out.should_receive(:puts).with(/^WARNING/)
          PodUtils.write_unless_exists("hello", file, [path1,path2], out)
        end
        
        it "Should return true" do
          PodUtils.write_unless_exists("hello", file, [path1,path2]).should be_true
        end
      end
      
      context "No paths exist" do
        it "Should raise exception" do
          lambda {raise "gggggggrrrr"}.should raise_error
        end
      end
    end
  end
end