class Group < ApplicationRecord
  CODE_LENGTH = 5

  validates :name, presence: true
  validates :code,
    presence: true,
    uniqueness: true,
    length: { is: CODE_LENGTH }
  validates :creator, presence: true

  belongs_to :creator, class_name: 'User'

  after_initialize do |group|
    group.code = Code.generate(CODE_LENGTH) if group.code.blank?
  end
end
