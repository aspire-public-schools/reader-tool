class AddFlaggedToObservationRead < ActiveRecord::Migration
    def self.up
     add_column :observation_reads, :flags, :boolean, :default => false
   end

   def self.down
     remove_column :observation_reads, :flags
   end
end
