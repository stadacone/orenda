class ReplaceUsersPermissionsByJoinTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :users_permissions

    create_join_table :permissions, :users
  end
end
