class User < ApplicationRecord
    has_secure_password
    has_many :companies
    validates :login_id, presence: true, uniqueness: true, length: {maximum: 20}
end
