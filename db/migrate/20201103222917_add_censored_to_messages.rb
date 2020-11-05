class AddCensoredToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :censored, :boolean, default: false
  end
end
