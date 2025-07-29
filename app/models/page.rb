class Page < ApplicationRecord
  belongs_to :site
  has_many :cards, dependent: :destroy

  def to_param
    slug
  end
end
