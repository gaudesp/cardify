FactoryBot.define do
  factory :card_content do
    type { "CardContent" }
    page
    after(:build) do |card|
      card.content = Faker::Lorem.paragraph if card.respond_to?(:content)
    end
  end
end
