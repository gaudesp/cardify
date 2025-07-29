require "faker"

5.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123"
  )

  site = Site.create!(
    user: user,
    title: Faker::Company.name,
    slug: Faker::Internet.unique.domain_word,
    published: [true, false].sample
  )

  2.times.with_index(1) do |_, i|
    page = Page.create!(
      site: site,
      title: Faker::Lorem.word.capitalize,
      slug: Faker::Internet.unique.slug,
      position: i
    )

    CardContent.create!(
      page: page,
      position: 1,
      content: "<h2>#{Faker::Lorem.sentence}</h2><p>#{Faker::Lorem.paragraph}</p>"
    )
  end
end
