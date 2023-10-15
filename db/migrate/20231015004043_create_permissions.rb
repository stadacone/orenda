class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.string :resource
      t.string :action

      t.timestamps
    end

    create_table :users_permissions do |t|
      t.belongs_to :user
      t.belongs_to :permission
    end
  end
end
