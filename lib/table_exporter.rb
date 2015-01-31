require 'CSV'
require 'pathname'
require 'fileutils'
CMO_NAME = "TCRP"

module TableExporter
  extend self

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def dump_tables
    directory.mkpath
    MODELS.each{|m| dump_table(m.constantize) }
    directory.parent.join( "#{CMO_NAME}_#{Date.today}.tgz").tap do |filename|
      `cd #{filename.dirname} && \
      tar -czvf #{filename.basename} #{File.join(CMO_NAME,"*.csv")}`
      FileUtils.rm_rf directory
    end
  end


  private

  def directory
    Rails.root.join( "tmp", CMO_NAME )
  end

  def dump_table model
    CSV.open(directory.join("#{model.name}.csv"), "w") do |csv|
      cols = model.column_names
      csv << cols
      model.all.each do |obj|
        csv << obj.attributes.values_at(*cols)
      end
    end
  end

end