class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.bigint :visiter_id, null: false
      t.bigint :visited_id, null: false
      t.bigint :post_id
      t.bigint :post_comment_id
      t.string :action, default: "", null: false
      t.boolean :checked, default: false, null: false
      t.timestamps
    end
    add_index :notifications, :visiter_id
    add_index :notifications, :visited_id
    add_index :notifications, :post_id
    add_index :notifications, :post_comment_id
  end
end
