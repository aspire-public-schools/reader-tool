class AddReaderRefToObservationReads < ActiveRecord::Migration
  def change
    add_column :observations, :reader_id, :integer
    add_index :observations, :reader_id
  end
end
