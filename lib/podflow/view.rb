require 'podflow/yamlable'

module Podflow
  class View
    include Yamlable
    attr_reader :name, :template
    
    def initialize(data = {})
      @name = data['name'] || 'MyView'
      @template = (data['template'] || 'my_view_template')
    end
    
    def render(bind, working_folder, stderr)
      if string = template_string(working_folder, stderr)
        "\n#{name}\n--\n#{ERB.new(string).result(bind)}\n--"
      else
        false
      end
    end
    
    private
    
    def template_string(working_folder, stderr)
      path = File.join(working_folder, 'templates', template + '.erb')
      
      if File.exist?(path)
        File.read(path)
      else
        stderr.puts("ERROR: No such template file: #{path}")
        false
      end
    end
  end
end