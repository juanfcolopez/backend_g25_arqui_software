class AddClosedToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :closed, :boolean, default: false
  end
end
