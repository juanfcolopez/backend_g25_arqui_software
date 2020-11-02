class RenameColumnValidToValidFlag < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :valid, :valid_flag
  end
end
