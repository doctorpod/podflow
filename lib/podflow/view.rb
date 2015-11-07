module Podflow
  class View
    attr_reader :name, :template

    def initialize(data = {})
      @name = data['name'] || 'MyView'
      @template = data['template'] || 'MyTemplateFile'
    end

    def render(series, episode, tmplt = PodUtils.local_template_string(template))
      "\n#{name}\n--\n#{ERB.new(tmplt).result(binding)}\n--"
    end
  end
end
