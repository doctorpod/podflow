require 'podflow/commands/command'
require 'podflow/series'
require 'podflow/episode'

module Podflow
  module Commands
    class ViewsCommand < Command
      def perform(episode_name, options = {}, series_class = Series, 
                    episode_class = Episode)
        config_path = find_file!(CONFIG_NAME, CONFIG_SEARCH_PATHS)
        episode_path = find_file!("#{episode_name}.yml", EPISODES_SEARCH_PATHS)
        series = series_class.load(File.read(config_path))
        episode = episode_class.load(File.read(episode_path))
        output.puts series.render_views(binding, working_folder, errput, false)
        SUCCESS
      end
    end
  end
end
