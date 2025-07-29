class SocialLink < ApplicationRecord
  belongs_to :site

  validates :platform, presence: true
  validates :url, presence: true

  ICONS = {
    instagram: "fab fa-instagram",
    facebook:  "fab fa-facebook",
    tiktok:    "fab fa-tiktok",
    youtube:   "fab fa-youtube",
    whatsapp:  "fab fa-whatsapp",
    linkedin:  "fab fa-linkedin",
    github:    "fab fa-github"
  }.freeze

  def icon_class
    ICONS[platform.to_sym] || "fas fa-link"
  end
end
