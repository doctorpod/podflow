require 'yaml'
require 'erb'

module Podflow
  module Yamlable
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def load(yaml_string)
        data_hash = YAML.load(yaml_string)
        new(data_hash)
      end
    end

    def to_yaml
      template = ERB.new(template_str, nil, '<>')
      template.result binding
    end
    
    private
    
    def template_str
      File.read(File.expand_path(File.join('..', '..', '..', 'templates',
        "#{self.class.to_s.split('::').last.downcase}.erb"), __FILE__))
    end

    def to_objects(obj_class, data_series)
      data_series.map { |data| obj_class.new(data) }
    end
  end
end