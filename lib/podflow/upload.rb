module Podflow
  class Upload
    include Yamlable
    attr_reader :name, :host, :path, :user, :pass
  
    def initialize(data = {})
      @name = data['name'] || 'MyName'
      @host = data['host'] || 'MyHost.com'
      @path = data['path'] || 'My/Path'
      @user = data['user'] || 'MyUser'
      @pass = data['pass'] || 'MyPassword'
    end
  end
end