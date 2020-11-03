class AddPrivateFlagToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :private, :boolean, default: false
  end
end
