class Group < ApplicationRecord
  CODE_LENGTH = 5

  validates :name, presence: true
  validates :code,
    presence: true,
    uniqueness: true,
    length: { is: CODE_LENGTH }
  validates :creator, presence: true

  belongs_to :creator, class_name: 'User'
  has_many :memberships, dependent: :destroy, inverse_of: :group
  has_many :users, through: :memberships

  after_initialize do |group|
    group.code = Code.generate(CODE_LENGTH) if group.code.blank?
  end

  after_create :add_creator_to_members

  def add_creator_to_members
    users << creator
  end
end
