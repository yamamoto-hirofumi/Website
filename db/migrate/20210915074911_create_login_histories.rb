class CreateLoginHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :login_histories do |t|
      t.bigint :user_id, null: false
      t.datetime :logind_at, null: false
      t.datetime :flashd_at

      t.timestamps
    end
    add_foreign_key :login_histories, :users
  end
end
