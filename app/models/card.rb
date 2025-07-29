class Card < ApplicationRecord
  belongs_to :page
  self.inheritance_column = :type
end
