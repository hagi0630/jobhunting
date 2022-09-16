class Company < ApplicationRecord
    belongs_to :user  #会社はuserに属する
    validates :name, presence: true
end
