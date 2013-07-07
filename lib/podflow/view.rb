module Podflow
  class View
    attr_reader :name, :template
    
    def initialize(data = {})
      @name = data['name'] || 'MyView'
      @template = data['template'] || 'MyTemplateFile'
    end
    
    def render(bind)
      "\n#{name}\n--\n#{ERB.new(template_string).result(bind)}\n--"
    end
    
    private
    
    def template_string
      path = File.join('./templates', template + '.erb')
      
      if File.exist?(path)
        File.read(path)
      else
        STDERR.puts("ERROR: No such template file: #{path}")
        exit
      end
    end
  end
end