require 'CSV'
require 'pathname'
require 'fileutils'

module TableExporter
  extend self

  MODELS = %w[ DomainScore IndicatorScore EvidenceScore ObservationRead ]

  def dump_tables cmo_name
    FileUtils.rm_rf directory(cmo_name).tap{|m| m.mkpath}.join("*")
    MODELS.each{|m| dump_table(m.constantize,cmo_name) }
  end

  private

  def directory cmo_name
    Rails.root.join( "tmp", cmo_name, "export" )
  end

  def dump_table model, cmo_name
    CSV.open(directory(cmo_name).join("#{model.name}.csv"), "w") do |csv|
      cols = model.column_names
      csv << cols
      model.all.each do |obj|
        csv << obj.attributes.values_at(*cols)
      end
    end
  end

end