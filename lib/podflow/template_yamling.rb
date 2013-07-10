module Podflow
  module TemplateYAMLing
    def to_yaml(template_path = 'templates')
      template = ERB.new(get_template_string(template_path), nil, '<>')
      template.result binding
    end
  
    def get_template_string(path)
      File.read(File.expand_path(File.join('..', '..', '..', path, "#{template_name}.erb"), __FILE__))
    end
    
    def template_name
      self.class.to_s.split("::").last.downcase
    end
    
    def to_objects(klass, data_array)
      data_array ? data_array.map {|data| klass.new(data)} : [klass.new]
    end
  end
end 
