class CreatePostComments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comments do |t|
      t.text :comment
      t.bigint :user_id
      t.bigint :post_id

      t.timestamps
    end
    add_foreign_key :post_comments, :users
    add_foreign_key :post_comments, :posts
  end
end
