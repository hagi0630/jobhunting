class RemovePassFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :password, :stringer
    remove_column :users, :login_pwd_digest, :stringer
  end
end
