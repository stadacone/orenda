class AddIndexesPermissionsUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :permissions_users, :permission_id
    add_index :permissions_users, :user_id
  end
end
