module Podflow
  module Commands
    class Command
      attr_reader :input, :output, :errput, :working_folder
      SUCCESS = 0
      FAILURE = 1
      CONFIG_NAME = 'series_config.yml'
      CONFIG_SEARCH_PATHS = ['config', '.']
      EPISODES_SEARCH_PATHS = ['episodes', '.']

      def initialize(working_folder = Dir.pwd, input = STDIN, output = STDOUT, errput = STDERR)
        @input = input
        @output = output
        @errput = errput
        @working_folder = working_folder
        Dir.chdir working_folder
      end

      private

      def find_file(file_name, paths)
        paths.each do |path|
          search = File.join(path, file_name)
          return search if File.exist?(search)
        end

        nil
      end
      
      def find_file!(file_name, paths)
        found = find_file(file_name, paths)
        
        if found.nil?
          puts "ERROR: Cannot find '#{file_name}' in #{paths.join(' or ')}"
          exit FAILURE
        else
          found
        end
      end
      
      def find_highest_file(pattern, paths)
        all = paths.each { |path| Dir.glob(File.join(path, pattern)) } .flatten
      end

      def write_unless_exists(contents, file_name, write_paths)
        write_paths.each do |write_path|
          if File.exist?(write_path)
            target = File.join(write_path, file_name)

            if File.exist?(target)
              errput.puts "ERROR: #{target} already exists"
              return FAILURE
            else
              File.open(target, 'w') {|f| f.write(contents)}
              output.puts "#{target} written"
              warn_of_redundencies(file_name, write_paths)
              return SUCCESS
            end
          end
        end

        errput.puts "ERROR: Cannot write #{file_name} - folder(s) not found: #{folder_paths.join(', ')}"
        FAILURE
      end

      def warn_of_redundencies(file_name, search_paths)
        default_exists = false

        search_paths.each do |path|
          search = File.join(path, file_name)

          if default_exists
            output.puts "WARNING: #{search} is redundant" if File.exist?(search)
          else
            default_exists = File.exist?(search)
          end
        end
      end
    end
  end
end