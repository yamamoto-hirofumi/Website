class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.bigint :user_id
      t.bigint :post_id

      t.timestamps
    end
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
  end
end
