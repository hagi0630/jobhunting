class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.integer :user_id
      t.string :name
      t.string :url
      t.string :mypage_id
      t.string :mypage_pwd
      t.string :task1
      t.datetime :due1
      t.string :task2
      t.datetime :due2
      t.string :task3
      t.datetime :due3
      t.string :task4
      t.datetime :due4

      t.timestamps
    end
  end
end
