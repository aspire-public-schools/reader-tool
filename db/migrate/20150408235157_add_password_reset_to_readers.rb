class AddPasswordResetToReaders < ActiveRecord::Migration
  def change
    add_column :readers, :password_reset_token, :string
    add_column :readers, :password_reset_sent_at, :datetime
  end
end
