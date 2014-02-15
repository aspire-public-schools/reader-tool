class CreateDomainScores < ActiveRecord::Migration
  def change
    create_table :domain_scores do |t|
      t.integer :observation_reads_id
      t.integer :quality_score
      t.integer :domain_id
    end
  end
end
