class Page < ApplicationRecord
  belongs_to :site
  has_many :cards, dependent: :destroy

  before_validation :generate_slug, on: :create
  validates :slug, presence: true, uniqueness: { scope: :site_id }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= label.to_s.parameterize
  end
end
