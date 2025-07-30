require "faker"

Faker::UniqueGenerator.clear

user = User.create!(
  email: "enzo@gmail.com",
  password: "password",
  password_confirmation: "password",
  first_name: "Enzo"
)

site = Site.create!(
  user: user,
  company_name: "Naro'StreetFood",
  phone_number: "0646786955",
  contact_email: "narostf@gmail.com",
  published: true,
  setting: {
    "theme": {
      "color_primary": "#82ced2",
      "color_secondary": "#7fb083",
      "background_gradient": "top right",
      "radius": "10px"
    }
  }
)

site.aside_image.attach(
  io: File.open(Rails.root.join("db/seeds/images/aside.jpg")),
  filename: "aside.jpg",
  content_type: "image/jpeg"
)

site.social_links.create!([
  { platform: "instagram", url: "https://www.instagram.com/narostreetfood/", position: 1 },
  { platform: "facebook",  url: "https://www.facebook.com/profile.php?id=100092345660473",  position: 2 }
])

page_info = Page.create!(
  site: site,
  title: "A propos",
  label: "info",
  icon: "info-circle",
  position: 1
)

page_menu = Page.create!(
  site: site,
  title: "Notre carte",
  label: "menu",
  icon: "utensils",
  position: 2
)

card_info = CardContent.create!(
  page: page_info,
  position: 1,
  content: """
  <p>
  Foodtruck spécialisé en arancini, basé dans le Pas-de-Calais.
  </p>

  <p>
  Chaque recette est préparée maison, à base de produits locaux soigneusement sélectionnés, pour vous offrir une cuisine authentique, généreuse et pleine de caractère.
  </p>

  <p>
  Retrouvez-nous régulièrement sur les marchés et événements de la région, et laissez-vous tenter par une pause gourmande aux saveurs de la Sicile.
  </p>
  """
)

card_menu = CardMenu.create!(
  page: page_menu,
  position: 2
)

arancini = card_menu.card_menu_categories.create!(
  title: "Plats",
  position: 1,
  card_menu_items_attributes: [
    { title: "Arancini", ingredients: "bolo, poulet, mortadelle, végé, thon", price: 4.50, position: 1 },
    { title: "Arancini Piccolo", ingredients: "bolo, poulet, mortadelle, végé, thon", price: 2.50, position: 2 }
  ]
)

desserts = card_menu.card_menu_categories.create!(
  title: "Desserts",
  position: 2,
  card_menu_items_attributes: [
    { title: "Tiramisu", ingredients: "café, speculoos, chocolat blanc, nutella", price: 3.50, position: 1 },
    { title: "Panettone 100 gr", subtitle: "en supp pour formule", price: 5.00, position: 2 },
    { title: "Panettone boîte métal 750 gr", price: 28.00, position: 3 }
  ]
)

boissons = card_menu.card_menu_categories.create!(
  title: "Boissons",
  position: 3,
  card_menu_items_attributes: [
    { title: "Limonade de Sicile", price: 1.50, position: 1 },
    { title: "San Pellegrino", price: 1.50, position: 2 },
    { title: "Bière italienne", price: 3.50, position: 3 },
    { title: "Chianti 37,5 cl", price: 5.50, position: 4 },
    { title: "Chianti 50 cl", price: 6.90, position: 5 }
  ]
)

formules = card_menu.card_menu_categories.create!(
  title: "Formules",
  position: 4,
  card_menu_items_attributes: [
    { title: "1 Arancini + 1 Dessert + 1 Boisson (soft)", price: 9.00, position: 1 }
  ]
)
