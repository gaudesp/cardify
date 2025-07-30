class CardMenu < Card
  has_many :card_menu_categories, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :card_menu

  accepts_nested_attributes_for :card_menu_categories, allow_destroy: true

  def to_partial_path
    "cards/card_menu"
  end
end
