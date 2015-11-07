require_relative '../../podflow'
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

desc 'Generate email messages for epsiode'
task :email do
  Episode.highest_or_matching(ENV['NAME']).email
end

desc 'Generate slack messages for epsiode'
task :slack do
  Episode.highest_or_matching(ENV['NAME']).slack
end

desc 'Tag, generate views, upload and generate messages for episode'
task :deploy => [:tag, :views, :upload, :email, :slack]

task :default => :deploy
