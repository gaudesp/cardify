class Site < ApplicationRecord
  belongs_to :user
  has_many :pages, dependent: :destroy

  def to_param
    slug
  end
end
