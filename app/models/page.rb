class Page < ApplicationRecord
  belongs_to :site
  has_many :cards, dependent: :destroy
end
