require 'podflow/commands/command'

module Podflow
  module Commands
    class EpisodeCommand < Command
      def perform(args, episode_class = Episode, options = {})
        mp3_search_paths = ['media', 'mp3', '.']
        write_paths = ['episodes', '.']
        episode = episode_class.new

        if episode_name = args.first
          episode.instance_eval { @number = (options['n'] || episode_name.to_i) }

          if matching_mp3 = find_file("#{episode_name}.mp3", mp3_search_paths)
            episode.read_mp3(matching_mp3)
          end

          write_unless_exists(episode.to_yaml, episode_name + '.yml', write_paths)
        else
          if greatest_mp3_file = find_greatest_episode('mp3', mp3_search_paths)
            episode.read_mp3(greatest_mp3_file)
            write_unless_exists(episode.to_yaml, File.basename(greatest_mp3_file, '.mp3') + '.yml', write_paths)
          else
            errput.puts "ERROR: Must specify an episode name as no MP3 files found from which to derive one"
            FAILURE
          end
        end
      end

      private

      def find_greatest_episode(ext, paths)
        paths.each do |path|
          search_glob = File.join(path, "*.#{ext}")
          found = Dir.glob(search_glob)
          return found.sort.last if found.any?
        end

        nil
      end
    end
  end
end