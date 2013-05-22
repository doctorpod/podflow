require 'podflow/commands/command'

module Podflow
  module Commands
    class SeriesCommand < Command
      def perform(series_class = Series)
        config_name = 'series_config.yml'
        write_paths = ['config', '.']
        write_unless_exists(series_class.new.to_yaml, config_name, write_paths)
      end
    end
  end
end