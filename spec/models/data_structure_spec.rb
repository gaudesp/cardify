require 'rails_helper'

RSpec.describe 'Data model structure', type: :model do
  it 'creates a user with one site, two pages and three content cards' do
    user = FactoryBot.create(:user)
    site = FactoryBot.create(:site, user:)

    concept_page = FactoryBot.create(:page, site:, title: "Concept", slug: "concept")
    menu_page = FactoryBot.create(:page, site:, title: "Menu", slug: "menu")

    concept_card = CardContent.create!(page: concept_page)
    concept_card.content = "Bienvenue sur notre food truck, où chaque produit est local."
    concept_card.save!

    boissons = CardContent.create!(page: menu_page)
    boissons.content = "🧃 Boissons : jus bio, limonade artisanale, café équitable"
    boissons.save!

    plats = CardContent.create!(page: menu_page)
    plats.content = "🥪 Plats : sandwichs maison, salades du jour, wraps végétariens"
    plats.save!

    plain_texts = menu_page.cards.map { |card| card.content.body.to_plain_text }

    expect(user.sites.count).to eq(1)
    expect(site.pages.count).to eq(2)
    expect(concept_page.cards.count).to eq(1)
    expect(menu_page.cards.count).to eq(2)
    expect(plain_texts.join).to include("Boissons")
    expect(plain_texts.join).to include("sandwichs")
  end
end
