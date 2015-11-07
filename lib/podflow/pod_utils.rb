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
        raise "Cannot find '#{file_name}' in #{paths.join(' or ')}"
      else
        found
      end
    end

    def self.write_unless_exists(contents, file_name, write_paths, out = STDOUT, err = STDERR)
      write_paths.each do |write_path|
        if File.exist?(write_path)
          target = File.join(write_path, file_name)

          if File.exist?(target)
            out.puts "#{target} already exists"
            return false
          else
            File.open(target, 'w') {|f| f.write(contents)}
            out.puts "#{target} written"
            warn_of_redundencies(file_name, write_paths, out)
            offer_edit(target)
            return true
          end
        end
      end

      raise "Cannot write #{file_name} - folder(s) not found: #{folder_paths.join(', ')}"
    end

    def self.warn_of_redundencies(file_name, search_paths, out = STDOUT)
      default_exists = false

      search_paths.each do |path|
        search = File.join(path, file_name)

        if default_exists
          out.puts "WARNING: #{search} is redundant" if File.exist?(search)
        else
          default_exists = File.exist?(search)
        end
      end
    end

    def self.offer_edit(path)
      if editor = ENV["EDITOR"]
        STDOUT.puts "Edit file? (y/n):"
        answer = STDIN.gets.chomp
        system "#{editor} #{path}" if %w{ y yes }.include?(answer.downcase)
      end
    end

    def self.local_template_string(name)
      path = File.join('./templates', name + '.erb')

      if File.exist?(path)
        File.read(path)
      else
        raise "No such template file: #{path}"
      end
    end

    def self.with_error_handling
      begin
        yield
      rescue Exception => e
        STDERR.puts "ERROR: #{e.message}\n"
        exit FAILURE
      end
    end
  end
end
