class AddUserRefToPosts < ActiveRecord::Migration[7.1]
  def change
    Post.delete_all
    add_reference :posts, :user, null: false, foreign_key: true
  end
end
