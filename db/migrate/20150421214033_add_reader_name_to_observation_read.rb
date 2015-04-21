class AddReaderNameToObservationRead < ActiveRecord::Migration
  def change
    add_column :observation_reads, :observer_name, :string
  end
end
