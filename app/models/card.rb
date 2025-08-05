class Card < ApplicationRecord
  belongs_to :page
  self.inheritance_column = :type
  validates :title, presence: true
end
