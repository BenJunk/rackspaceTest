class User < ActiveRecord::Base
  attr_accessible :name, :years, :address, :city, :state, :zip, :school, :years, :type, :code, :email, :password, :password_confirmation 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :name, length: { maximum: 35 }
  validates :zip, length: { maximum: 5 }
  validates :zip, numericality: { only_integer: true }
  validates :years, numericality: { only_integer: true }, if: :register_as_owner_vet?
  validates :years, :inclusion => 1..100, if: :register_as_owner_vet?
  validates :years, presence: true, if: :register_as_owner_vet?
  validates :code, presence: true

  def register_as_owner_vet?
    type == "owner" || type == "veterinarian"
  end
end