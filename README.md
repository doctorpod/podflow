# Podflow

Podflow is a suite of Rake tasks to streamline the process of audio podcast tagging, deployment and delivery, and RSS generation and maintenance.

## Installation

    $ sudo gem install podflow

## Setting up a podcast series

    $ podify

Generates a Rakefile in the current folder which defines the following tasks:

    $ rake config

Generates a common configuration file for a podcast series named *series_config.yml*. The file is written to any folder named *config* else the current folder. Existing configuration files will not be overwritten. All podflow commands expect to find this file in any folder named *config* else the current folder.

    $ rake episode [NUMBER=n] [NAME=name]

Creates an episode file for an MP3 file. If NAME is omitted the highest alphabetically sorted MP3 file is assumed (searches any folder named *media*, *mp3* else the current folder). The resulting file is written to any folder named *episodes* else the current folder. The following values are pre-populated: *number:*, *year:* and *pubdate:* are based on the current time, and *explicit:* defaults to the value set in *series_config.yml*. If the MP3 file is already tagged, these values are used to pre-populate the corresponding values in the episode file. Existing episode files will not be overwritten.

The *NUMBER* env variable indicates the episode number. If omitted this is derived from the name if it begins with a number. If it can't be derived, 0 is assumed.

## Deploying a podcast episode

    $ rake deploy [NAME=name]
    $ rake tag [NAME=name]
    $ rake views [NAME=name]
    $ rake upload [NAME=name]
    $ rake inform [NAME=name]

These commands perform tag, upload, text generation (view) and inform steps on an episode. The *deploy* task performs all steps in the order specified above. If *NAME* is omitted the highest alphabetically sorted episode file is assumed (searches any folder named *episodes* else the current folder). Which steps are performed are governed by the values set in the *series_config.yml* file.


## Generating an RSS feed

    $ feedify

Generates a Rakefile in the current folder which defines the following tasks:

    $ rake config NAME=name

A new feed config file is created in any folder named *config* else the current folder. Existing config files will not be overwritten.

Feed config files have the following format:

    title:
    author:
    description:
    explicit:
    language:
    ttl:
    keywords:
      - 
    
    website:
    copyright:
    webmaster:
    ownername:
    owneremail:
    artwork1400:
    artwork600:
    artwork300:
    artwork144:
    
    series:
      - 
      
    uploads:
      - 
        name:
        host:
        path:
        user:
        pass:
    
    informs:
      -
        subject:
        recipients:
        from:
        template:

 

    $ rake generate [NAME=name]

For each config file (.yml) found in any folder named *config*, else the current folder, generates an RSS feed in any folder named *out*, else the current folder. If *NAME* is supplied just generates the feed for correspondingly named .yml file.

    $ rake upload NAME=name

Uploads the named feed file (.xml) from any folder named *out*, else the current folder. NAME must be supplied.

    $ rake inform NAME=name

Sends emails for named feed. NAME must be supplied.

## Templates

The *template:* values in the *series_config.yml* and episode files should specify the name of an ERB template file without the extension. They will be searched for in a *templates* folder which must exist, and are expected to have an *.erb* extension. Podflow makes two objects available to templates in the *series_config.yml* file: *series* and *episode*, and a *feed* object available to templates in feed config files. The attributes of these objects are a direct match to the corresponding YAML files, including nested objects. Examples of valid expressions would be:

    series.name
    series.description
    
    series.views.each do |view|
      view.name
    end
    
    episode.number
    
    episode.images.each do |image|
      image.alt
    end
    
    feed.title
    feed.keywords.join(', ')
    
    feed.series.each do |series|
      series.name
      series.description
    end


## Images

The *images: file:* values in the episode files should be a filename and extension and will be searched in an *images* or *img* folder, one of which must exist.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
