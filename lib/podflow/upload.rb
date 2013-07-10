require 'podflow/uploader'

module Podflow
  class Upload
    attr_reader :name, :host, :path, :user, :pass
  
    def initialize(data ={})
      @name = data['name'] || 'MyName'
      @host = data['host'] || 'MyHost.com'
      @path = data['path'] || 'My/Path'
      @user = data['user'] || 'MyUser'
      @pass = data['pass'] || 'MyPassword'
    end
    
    def perform(file_path)
      Uploader.perform file_path, {'host' => host, 'path' => path, 'user' => user, 'pass' => pass}
    end
  end
end