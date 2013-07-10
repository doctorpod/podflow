require 'podflow/pod_utils'

module Podflow
  class View
    attr_reader :name, :template
    
    def initialize(data = {})
      @name = data['name'] || 'MyView'
      @template = data['template'] || 'MyTemplateFile'
    end
    
    def render(series, episode)
      "\n#{name}\n--\n#{ERB.new(PodUtils.local_template_string(template)).result(binding)}\n--"
    end
  end
end