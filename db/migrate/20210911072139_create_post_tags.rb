class CreatePostTags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_tags do |t|
      t.bigint :post_id
      t.bigint :tag_id

      t.timestamps
    end
    add_index :post_tags, [:post_id, :tag_id], unique: true
    add_foreign_key :post_tags, :posts
    add_foreign_key :post_tags, :tags
  end
end
