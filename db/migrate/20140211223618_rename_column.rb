class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :readers, :empolyeenumber, :employeenumber
  end

end
