class AddValidFlagToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :valid, :boolean, default: false
  end
end
