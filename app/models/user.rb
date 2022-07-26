class User < ApplicationRecord
    has_secure_password   # パスワード処理
    has_many :companies   #1つのUserが複数の会社登録してる
    validates :login_id, presence: true, uniqueness: true, length: {maximum: 20} #ログインIDの被りなし
end
