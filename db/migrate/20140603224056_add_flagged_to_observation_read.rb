class AddFlaggedToObservationRead < ActiveRecord::Migration
  def change
    add_column :observation_reads, :flags, :boolean, :default => false
  end
end
