class RenameObservationsToObservationReads < ActiveRecord::Migration
  def up
    rename_table :observations, :observation_reads
  end

  def down
    rename_table :observations, :observation_reads
  end
end
