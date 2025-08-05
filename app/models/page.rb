class Page < ApplicationRecord
  belongs_to :site
  acts_as_list scope: :site
  has_many :cards, dependent: :destroy
  accepts_nested_attributes_for :cards, allow_destroy: true

  before_validation :generate_slug, on: :create
  validates :slug, presence: true, uniqueness: { scope: :site_id }
  validates :label, presence: true, uniqueness: { scope: :site_id }
  validates :icon, presence: true, uniqueness: { scope: :site_id }

  def to_param
    slug
  end

  def label
    super&.upcase
  end

  private

  def generate_slug
    self.slug ||= label.to_s.parameterize
  end
end
