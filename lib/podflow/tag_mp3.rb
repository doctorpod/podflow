require 'taglib'
require "mp3info"

module Podflow
  module TagMP3
    def self.write_artwork( mp3_file, artwork_file )
      raise "No such MP3 file #{mp3_file}" unless File.exist?(mp3_file)
      raise "No such artwork file #{artwork_file}" unless File.exist?(artwork_file)
      raise "Artwork file must be .jpg: #{artwork_file}" unless artwork_file =~ /\.jpg$/i
    
      file = TagLib::MPEG::File.new(mp3_file)
      file_tags = file.id3v2_tag
      # Clear all existing APIC frames
      file_tags.remove_frames('APIC')

      # Add attached picture frame
      apic = TagLib::ID3v2::AttachedPictureFrame.new
      apic.mime_type = "image/jpeg"
      apic.description = "Cover"
      apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
      apic.picture = File.open(artwork_file, 'rb'){ |f| f.read }
      file_tags.add_frame(apic)

      file.save
    end

    def self.write_tags( file, values = {} )
      raise "No such MP3 file #{file}" unless File.exist?(file)
      known_tags = [:name, :album, :artist, :comments, :genre, :year, :track, :artwork, :lyrics]
      values.each_key { |key| raise "Unknown tag #{key}" unless known_tags.include?(key) }

      Mp3Info.open(file) do |mp3|
        mp3.tag.title = values[:name] unless values[:name].nil?
        mp3.tag.album = values[:album] unless values[:album].nil?
        mp3.tag.artist = values[:artist] unless values[:artist].nil?
        mp3.tag.comments = values[:comments] unless values[:comments].nil? 
    
        # mp3.tag2.USLT are the Lyrics!
        mp3.tag2.USLT = "\000eng\000" + values[:lyrics] + "\000" unless values[:lyrics].nil?
    
        mp3.tag.genre_s = values[:genre] unless values[:genre].nil?
        mp3.tag.year = values[:year].to_i unless values[:year].nil?
        mp3.tag.tracknum = values[:track].to_i unless values[:track].nil?
      end
    
      write_artwork( file, values[:artwork] ) unless values[:artwork].nil?
    end
  
    def self.read_tags( file, tag = nil )
      raise "No such MP3 file #{file}" unless File.exist?(file)
      values = {}
      Mp3Info.open(file) do |mp3|
        values[:name]     = mp3.tag.title unless mp3.tag.title.nil?
        values[:album]    = mp3.tag.album unless mp3.tag.album.nil?
        values[:artist]   = mp3.tag.artist unless mp3.tag.artist.nil?
        values[:comments] = mp3.tag.comments unless mp3.tag.comments.nil?
        values[:lyrics]   = mp3.tag2.USLT.sub("\000eng\000",'') unless mp3.tag2.USLT.nil?
        values[:genre]    = mp3.tag.genre_s unless mp3.tag.genre_s.nil?
        values[:track]    = mp3.tag.tracknum unless mp3.tag.tracknum.nil?

        unless mp3.tag.year.nil? && mp3.tag1.year.nil? && mp3.tag2.TYER.nil? && mp3.tag2.TDRC.nil?
          values[:year] = (mp3.tag.year || mp3.tag1.year || mp3.tag2.TYER || mp3.tag2.TDRC).to_i
        end
      end
      tag.nil? ? values : values[tag]
    end
  end
end