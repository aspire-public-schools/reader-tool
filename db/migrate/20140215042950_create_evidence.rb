class CreateEvidence < ActiveRecord::Migration
  def change
    create_table :evidence do |t|
      t.integer :indicator_scores_id
      t.string :description
      t.string :type
      t.integer :true_score_id
    end
  end
end
