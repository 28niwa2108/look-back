class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, format: {
    with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i ,
    message: 'は半角英数字の混合で設定してください',
    allow_blank: true
  }
  validates :nickname, presence: true, length: { maximum: 6 }
  has_many :subscriptions, dependent: :destroy
  has_many :reviews
end
