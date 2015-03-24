require 'net/sftp'

# TODO: do this in a cron job
ENV['CMO'] = "TCRP_test"

namespace :schoolzilla do

  desc "import CSV from schoozilla FTP server"
  task :import => :environment do
    filename    = 'raw_BloomBoard_vw.csv'
    remote_path = File.join(ENV['CMO'],'export',filename)
    local_path  = Rails.root.join('tmp',ENV['CMO'],'import')
    Rails.logger.info "downloading CSV from schoolzilla SFTP"
    # sftp_connection do |sftp|
    #   p remote_path, local_path
    #   sftp.download! remote_path.to_s, local_path.join(filename).to_s
    #   sftp.loop 
    # end
    Rails.logger.info "importing tables from CSV..."
    TableImporter.import_from_csv local_path.join(filename)
    Rails.logger.info "done!"
  end

  desc "export CSVs to schoozilla FTP server"
  task :export => :environment do
    Rails.logger.info "dumping tables to CSV..."
    TableExporter.dump_tables(ENV['CMO'])
    remote_path = Pathname.new(ENV['CMO']).join('import')
    local_path  = Rails.root.join('tmp', ENV['CMO'],'export')
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
