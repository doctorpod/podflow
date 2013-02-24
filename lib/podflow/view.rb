module Podflow
  class View
    attr_reader :name, :template
    
    def initialize(data = {})
      @name = data['name'] || 'MyName'
      @template = data['template'] || 'MyTemplateFile'
    end
  end
end