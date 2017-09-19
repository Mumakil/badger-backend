class User < ApplicationRecord
  validates :name, presence: true
  validates :fbid, presence: true, uniqueness: true
  validates :avatar_url, presence: true

  has_many :created_groups, dependent: :destroy
  has_many :memberships, dependent: :destroy, inverse_of: :user
  has_many :groups, through: :memberships
end
