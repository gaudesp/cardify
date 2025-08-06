class Page < ApplicationRecord
  belongs_to :site
  acts_as_list scope: :site
  has_many :cards, -> { order(:position) }, inverse_of: :page, dependent: :destroy
  accepts_nested_attributes_for :cards, allow_destroy: true

  before_validation :generate_slug, on: :create
  validates :slug, presence: true, uniqueness: { scope: :site_id }
  validates :tab, presence: true, uniqueness: { scope: :site_id }
  validates :icon, presence: true, uniqueness: { scope: :site_id }

  def to_param
    slug
  end

  def tab
    super&.upcase
  end

  private

  def generate_slug
    self.slug ||= tab.to_s.parameterize
  end
end
