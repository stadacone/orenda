class AddPermissionUniqueness < ActiveRecord::Migration[7.1]
  def change
    add_index :permissions, [:action, :resource], unique: true
  end
end
