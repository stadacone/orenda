class AddImageSourceToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :image_source, :string
  end
end
