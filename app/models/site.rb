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

  def to_param
    slug
  end

  private

  def generate_slug
    return unless new_record? || company_name_changed?

    self.slug = company_name.to_s.parameterize
  end
end
