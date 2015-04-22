require 'net/sftp'
require 'fileutils'

# TODO: run this on a nightly schedule
# https://devcenter.heroku.com/articles/scheduler

namespace :schoolzilla do

  desc "import CSV from schoozilla FTP server"
  task :import => :environment do
    begin
      filename    = ENV['FILENAME'] || 'raw_BloomBoard_vw.csv'
      raise "ENV['ORG_*'] not configured for this branch!" if ENV['ORG_SFTP_DIR'].blank?
      remote_path = File.join(ENV['ORG_SFTP_DIR'],'export',filename)
      local_path  = Rails.root.join('tmp',ENV["ORG_NAME_SHORT"],'import')
      FileUtils.mkdir_p local_path
      Rails.logger.info "downloading CSV from schoolzilla SFTP"
      file = local_path.join(filename)
      unless file.exist? && ENV['SKIP_FTP']
        FileUtils.rm_f file
        sftp_connection do |sftp|
          # p remote_path, local_path
          sftp.download! remote_path.to_s, file.to_s
          sftp.loop 
        end
      end
      Rails.logger.info "importing all Evidence from CSV..."
      `tr < #{file} -d '\\000' > #{file}.clean`

      TableImporter.import_from_csv "#{file}.clean", ENV['TRUNCATE'] || false
      Rails.logger.info "cleanup up..."
      FileUtils.rm_f "#{file}.clean"
      Evidence.truncate!
      Rails.logger.info "done!"
    end
  end

  desc "export CSVs to schoozilla FTP server"
  task :export => :environment do
    Rails.logger.info "dumping tables to CSV..."
    TableExporter.dump_tables(ENV["ORG_NAME_SHORT"])
    remote_path = Pathname.new(ENV['SFTP_DIR']).join('import')
    local_path  = Rails.root.join('tmp', ENV["ORG_NAME_SHORT"],'export')
    FileUtils.mkdir_p local_path
    Rails.logger.info "uploading CSVs to schoolzilla SFTP"
    sftp_connection do |sftp|
      # sftp.mkdir! remote_path
      local_path.children.each do |local_file|
        remote_file = remote_path.join( local_file.basename )
        p local_file, remote_file
        sftp.upload! local_file.to_s, remote_file.to_s
        sftp.loop 
      end
    end
    Rails.logger.info "done!"
  end

  def sftp_connection
    raise ArgumentError, "no block given!" unless block_given?
    Net::SFTP.start(ENV['SFTP_SERVER'],ENV['SFTP_LOGIN'], password: ENV['SFTP_PASSWORD']) do |sftp|
      yield sftp
    end
  rescue IOError => e  
    Rails.logger.info "SFTP connection closed"
  end

end
