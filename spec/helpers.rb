def samples(*path_components)
  generate_path('samples', *path_components)
end

def sandbox(*path_components)
  generate_path('sandbox', *path_components)
end

def generate_path(folder_name, *path_components)
  path = File.expand_path(File.join('..', '..', folder_name), __FILE__)
  path_components.inject(path) { |path, component| File.join(path, component) }
end

def set_sandbox
  system "rm -fr #{sandbox} && mkdir #{sandbox}"
end

def copy_sample_to_sandbox(sample_path, sandbox_path = '')
  system "cp #{samples(sample_path)} #{sandbox(sandbox_path)}"
end

def in_sandbox(*path_components)
  Dir.chdir(sandbox(path_components)) { yield }
end

class String
  def blank_times
    self.sub(/\d\d\d\d\/\d\d\/\d\d \d\d:\d\d/,'0000/00/00 00:00').sub(/\d\d\d\d/,'0000')
  end
end

RSpec::Matchers.define :be_present do
  match do |path|
    File.exist?(path)
  end
end

RSpec::Matchers.define :be_zero_size do
  match do |path|
    File.size(path) == 0
  end
end

module Podflow
  class FakeSeries
    def to_yaml
      'fake series'
    end
    
    def render_views(binding)
      ['fake view 1', 'fake view 2']
    end
  end
  
  class FakeEpisode
    attr_reader :number
    
    def read_mp3
    end
    
    def to_yaml
      'fake episode'
    end
  end
end