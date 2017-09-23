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
  has_many :members, through: :memberships, class_name: 'User', source: :user

  after_initialize do |group|
    group.generate_code! if group.code.blank?
  end

  after_create :add_creator_to_members

  def generate_code!
    self.code = Code.generate(CODE_LENGTH)
  end

  def add_creator_to_members
    members << creator
  end
end
