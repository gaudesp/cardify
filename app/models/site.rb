class Site < ApplicationRecord
  belongs_to :user
  has_many :pages, dependent: :destroy
  has_many :social_links, dependent: :destroy
  has_one_attached :aside_image

  accepts_nested_attributes_for :social_links, allow_destroy: true, reject_if: :all_blank

  before_validation :generate_slug
  validates :slug, presence: true, uniqueness: true

  validates :contact_email,
    presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }

  validates :phone_number,
    presence: true,
    format: { with: /\A\+?[0-9\s\-().]{7,20}\z/, message: "is invalid" }
  
  before_save :normalize_radius

  def to_param
    slug
  end

  private

  def generate_slug
    return unless new_record? || company_name_changed?

    self.slug = company_name.to_s.parameterize
  end

  def normalize_radius
    raw_radius = setting.dig("radius") || setting.dig("theme", "radius")

    return if raw_radius.blank?

    radius_px = raw_radius.to_s.gsub("px", "").to_i
    setting["theme"] ||= {}
    setting["theme"]["radius"] = "#{radius_px}px"
  end
end
