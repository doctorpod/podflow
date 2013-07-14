require 'podflow'
include Podflow

desc "Generate config file #{Series::CONFIG_NAME}"
task :config do
  Series.write
end

desc 'Generate episode file'
task :episode do
  Episode.generate_config_file(ENV['NAME'], ENV['NUMBER'])
end

desc 'Tag episode'
task :tag do
  Episode.highest_or_matching(ENV['NAME']).write_tags
end

desc 'Render views for episode'
task :views  do
  STDOUT.puts Series.load.render_views(ENV['NAME'])
end

namespace :upload do
  desc 'Upload episode'
  task :episode do
    Episode.highest_or_matching(ENV['NAME']).upload
  end

  desc 'Upload images'
  task :images do
    Episode.highest_or_matching(ENV['NAME']).upload_images
  end
end

task :upload => ['upload:episode', 'upload:images']

desc 'Generate inform messages for epsiode'
task :inform do
  Episode.highest_or_matching(ENV['NAME']).inform
end

desc 'Tag, generate views, upload and generate inform messages for episode'
task :deploy => [:tag, :views, :upload, :inform]

task :default => :deploy