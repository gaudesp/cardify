FactoryBot.define do
  factory :site do
    title { "Le food truck du coin" }
    slug { "food-truck" }
    user
  end
end
