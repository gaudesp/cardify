class CardMenuItem < ApplicationRecord
  belongs_to :card_menu_category

  acts_as_list scope: :card_menu_category

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
