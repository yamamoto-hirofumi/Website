class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :image_id
      t.timestamps
    end
    add_foreign_key :posts, :users
  end
end
