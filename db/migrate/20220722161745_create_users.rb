class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :login_id
      t.string :login_pwd_digest

      t.timestamps
    end
  end
end
