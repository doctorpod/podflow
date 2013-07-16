require 'erb'
require 'yaml'

module Podflow
  class FormattedConfigFile
    def initialize(data = nil)
      @settings = {}
      @children = {}
      data.nil? ? set_defaults : load_data(data)
    end
    
    def set_defaults
      self.class.instance_eval { @settings || {} } .each do |key, default|
        @settings[key] = default
      end

      self.class.instance_eval { @children || {} } .each do |key, klass|
        @children[key] = [klass.new]
      end
    end
    
    def self.has_setting(sym, default)
      @settings ||= {} # Class instance variable
      @settings[sym] = default
    
      define_method sym do
        @settings ||= {} # Instance variable
        @settings[sym]
      end

      define_method "#{sym}=" do |val|
        @settings ||= {} # Instance variable
        @settings[sym] = val
      end
    end
  
    def self.has_children(sym, klass)
      @children ||= {} # Class instance variable
      @children[sym] = klass

      define_method sym do
        @children ||= {} # Instance variable
        @children[sym]
      end

      define_method "#{sym}<<" do |val|
        @children ||= {}
        @children[sym] << val
      end
    end
  
    def load_data(data_hash)
      symbolise(data_hash).each do |key, val|
        if self.class.instance_eval { @settings.has_key?(key) }
          @settings[key] = val.is_a?(String) ? val.chomp : val
        elsif self.class.instance_eval { @children.has_key?(key) }
          @children[key] = []
          
          unless val.nil?
            val.each do |child|
              @children[key] << self.class.instance_eval { @children[key] } .new(child)
            end
          end
        else
          raise "No such setting: #{key}"
        end
      end
    end
    
    def load_file(path)
      load_data(YAML.load(File.read(path)))
    end
    
    def symbolise(string_keyed_hash)
      string_keyed_hash.inject({}) {|symboly, (k,v)| symboly[k.to_sym] = v; symboly}
    end
    
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
  end
end 
