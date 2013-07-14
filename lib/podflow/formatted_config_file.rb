require 'erb'

module Podflow
  class FormattedConfigFile
    def to_yaml(tmpl_path = template_path)
      template = ERB.new(File.read(tmpl_path), nil, '<>')
      template.result binding
    end
  
    # We don't expect this to fail! The template is part of this gem.
    def template_path
      File.expand_path(File.join('..', '..', '..', 'templates', "#{template_name}.erb"), __FILE__)
    end
    
    def template_name
      self.class.to_s.split("::").last.downcase
    end
    
    def to_objects(klass, data_array)
      data_array ? data_array.map {|data| klass.new(data)} : []
    end
  end
end 
