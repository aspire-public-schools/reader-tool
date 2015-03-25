class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :observation_reads, :reader_id
    add_index :domain_scores, :observation_read_id
    add_index :domain_scores, :domain_id
    add_index :evidence_scores, :indicator_score_id
    add_index :indicators, :domain_id
    add_index :indicator_scores, :indicator_id
    add_index :indicator_scores, :domain_score_id
    add_index :indicator_scores, [:domain_score_id, :indicator_id]
  end
end
