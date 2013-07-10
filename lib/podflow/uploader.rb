require "net/ftp"

module Podflow
  module Uploader
    def self.perform(path, opts)
      remote_size = 0
      local_size = File.size(path)
      STDOUT.sync = true
      STDOUT.print "#{path} uploading to #{opts['host']}:#{opts['path']} - this may take a while... "

      Net::FTP.open(opts["host"]) do |ftp|
        ftp.login opts["user"], opts["pass"]
        ftp.chdir opts["path"]
        ftp.putbinaryfile path
        remote_size = ftp.list(File.basename(path)).last.split(" ")[4].to_i
      end
    
      STDOUT.puts "done\n   Local size: #{local_size}\n  Remote size: #{remote_size}"
      return (remote_size == local_size)
    end
  end
end
