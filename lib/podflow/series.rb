module Podflow
  class Series < FormattedConfigFile
    has_setting :name, "MyName"
    has_setting :artist, "MyArtist"
    has_setting :description, 'MyDescription'
    has_setting :artwork, 'MyArtwork.jpg'
    has_setting :media_uri, 'http://my.media/uri'
    has_setting :genre, 'Podcast'
    has_setting :slack_url, 'https://hooks.slack.com/services/SET/THIS'
    has_setting :slack_username, 'Andy'
    has_setting :slack_channel, '@andy'

    has_children :uploads, Upload
    has_children :views, View
    has_children :email, Email
    has_children :slack, Slack

    CONFIG_NAME = 'series_config.yml'
    CONFIG_SEARCH_PATHS = ['config', '.']
    ARTWORK_SEARCH_PATHS = ['images', 'img']

    def self.config_path
      PodUtils::find_file!(CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end

    def artwork_path
      PodUtils::find_file!(artwork, ARTWORK_SEARCH_PATHS)
    end

    def render_views(episode_name)
      PodUtils.with_error_handling do
        episode = Episode.highest_or_matching(episode_name)
        views.map { |view| view.render(self, episode) } .join
      end
    end

    # Load from an existing config file
    def self.load(path = config_path)
      new YAML.load(File.read(path))
    end

    def self.write
      PodUtils.write_unless_exists(new.to_yaml, CONFIG_NAME, CONFIG_SEARCH_PATHS)
    end
  end
end
