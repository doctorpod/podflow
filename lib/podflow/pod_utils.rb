module Podflow
  module PodUtils
    SUCCESS = 0
    FAILURE = 1

    def self.find_file(file_name, paths)
      paths.each do |path|
        search = File.join(path, file_name)
        return search if File.exist?(search)
      end

      nil
    end
    
    def self.find_file!(file_name, paths)
      found = find_file(file_name, paths)
      
      if found.nil?
        puts "ERROR: Cannot find '#{file_name}' in #{paths.join(' or ')}"
        exit FAILURE
      else
        found
      end
    end
    
    def self.write_unless_exists(contents, file_name, write_paths)
      write_paths.each do |write_path|
        if File.exist?(write_path)
          target = File.join(write_path, file_name)

          if File.exist?(target)
            STDERR.puts "ERROR: #{target} already exists"
            return FAILURE
          else
            File.open(target, 'w') {|f| f.write(contents)}
            STDOUT.puts "#{target} written"
            warn_of_redundencies(file_name, write_paths)
            return SUCCESS
          end
        end
      end

      STDERR.puts "ERROR: Cannot write #{file_name} - folder(s) not found: #{folder_paths.join(', ')}"
      FAILURE
    end

    def self.warn_of_redundencies(file_name, search_paths)
      default_exists = false

      search_paths.each do |path|
        search = File.join(path, file_name)

        if default_exists
          STDOUT.puts "WARNING: #{search} is redundant" if File.exist?(search)
        else
          default_exists = File.exist?(search)
        end
      end
    end
  end
end
