class Site < ApplicationRecord
  belongs_to :user
  has_many :pages, -> { order(:position) }, dependent: :destroy
  has_many :social_links, dependent: :destroy
  has_one_attached :aside_image

  accepts_nested_attributes_for :social_links, allow_destroy: true

  before_validation :generate_slug
  validates :company_name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  validates :contact_email,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" },
    allow_blank: true

  validates :phone_number,
    format: { with: /\A\+?[0-9\s\-().]{7,20}\z/, message: "is invalid" },
    allow_blank: true
  
  before_save :normalize_radius

  def to_param
    slug
  end

  private

  def generate_slug
    return unless (new_record? || company_name_changed?) && company_name.present?

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
