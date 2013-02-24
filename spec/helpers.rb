def samples(file_name = '')
  File.expand_path(File.join('..', '..', 'samples', file_name), __FILE__)
end

class String
  def blank_times
    self.sub(/\d\d\d\d\/\d\d\/\d\d \d\d:\d\d/,'').sub(/\d\d\d\d/,'')
  end
end