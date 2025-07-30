class CardMenuCategory < ApplicationRecord
  belongs_to :card_menu
  has_many :card_menu_items, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :card_menu_category

  acts_as_list scope: :card_menu

  validates :title, presence: true

  accepts_nested_attributes_for :card_menu_items, allow_destroy: true
end
