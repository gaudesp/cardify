user = User.create!(
  email: "gaudesp@gmail.com",
  password: "password",
  password_confirmation: "password",
  first_name: "Gauthier",
  last_name: "Desplanque"
)

# Naro'StreetFood
site = Site.create!(
  user: user,
  company_name: "Naro'StreetFood",
  phone_number: "0646786955",
  contact_email: "narostf@gmail.com",
  published: true,
  setting: {"theme"=>{"radius"=>"30px", "color_primary"=>"#7caa7c", "color_secondary"=>"#7eb0c2", "background_gradient"=>"bottom right"}}
)

site.aside_image.attach(
  io: File.open(Rails.root.join("db/seeds/images/naro_streetfood.jpg")),
  filename: "naro_streetfood.jpg",
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
    { title: "Panettone", ingredients: "100 gr", subtitle: "en supp pour formule", price: 5.00, position: 2 },
    { title: "Panettone", ingredients: "750 gr, boîte métal", price: 28.00, position: 3 }
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

# Pizza Kea
site = Site.create!(
  user: user,
  company_name: "Pizza Kea",
  phone_number: "0780977831",
  contact_email: "pizzakea@gmail.com",
  published: true,
  setting: {"theme"=>{"radius"=>"15px", "color_primary"=>"#bd2b2f", "color_secondary"=>"#489f5f", "background_gradient"=>"right"}}
)

site.aside_image.attach(
  io: File.open(Rails.root.join("db/seeds/images/pizza_kea.jpg")),
  filename: "pizza_kea.jpg",
  content_type: "image/jpeg"
)

site.social_links.create!([
  { platform: "facebook",  url: "https://www.facebook.com/profile.php?id=100063543250793",  position: 1 }
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
  Foodtruck spécialisé en pizza, basé dans le Pas-de-Calais.
  </p>

  <p>
  Je vous propose des Pizzas cuites au feu de bois dans l'esprit des produits locaux, la Welsh avec son cheddar en passant par la Ch'ti au parfum du maroilles.
  </p>

  <p>
  Venez déguster d'autres recettes en base tomate ou crème. N'oubliez pas de passer vos commandes !
  </p>
  """
)

card_menu = CardMenu.create!(
  page: page_menu,
  position: 2
)

tomate = card_menu.card_menu_categories.create!(
  title: "Base Tomate",
  position: 1,
  card_menu_items_attributes: [
    { title: "Margarita", ingredients: "Mozzarella, Emmental, Olives noires", price: 9.50, position: 1 },
    { title: "Royale", ingredients: "Jambon blanc, Champignon blanc, Œuf, Mozzarella, Emmental, Olives noires", price: 11.50, position: 2 },
    { title: "Ch’ti", ingredients: "Jambon cru, Maroilles, Mozzarella, Emmental, Olives noires", price: 13.50, position: 3 },
    { title: "Sicilienne (anchois)", ingredients: "Filets d’anchois à l’huile, Mozzarella, Emmental, Olives noires", price: 12.50, position: 4 },
    { title: "Charcutière", ingredients: "Jambon blanc, Chorizo, Lardons fumés, Œuf, Mozzarella, Emmental, Olives noires", price: 12.50, position: 5 },
    { title: "Peppéroni", ingredients: "Peppéroni, Mozzarella, Emmental, Olives noires", price: 12.00, position: 6 },
    { title: "Végétarienne", ingredients: "Champignon blanc, Oignon, Aubergine, Tomate confite, Poivron, Mozzarella, Emmental, Olives noires", price: 11.50, position: 7 },
    { title: "Basquaise", ingredients: "Filet de poulet, Poivron, Champignon blanc, Oignon, Mozzarella, Emmental, Olives noires", price: 12.50, position: 8 },
    { title: "Rustique", ingredients: "Jambon blanc, Lardons fumés, Œuf, Mozzarella, Emmental, Olives noires", price: 11.50, position: 9 },
    { title: "Pizza Kea", ingredients: "Chorizo, Champignon blanc, Œuf, Mozzarella, Emmental, Olives noires", price: 11.50, position: 10 }
  ]
)

creme = card_menu.card_menu_categories.create!(
  title: "Base Crème",
  position: 2,
  card_menu_items_attributes: [
    { title: "Paysanne", ingredients: "Lardons fumés, Pomme de terre, Oignons, Œuf, Mozzarella, Emmental, Olives noires", price: 11.50, position: 1 },
    { title: "5 Fromages", ingredients: "Roquefort, Cheddar, Fromage à raclette, Mozzarella, Emmental, Olives noires", price: 13.50, position: 2 },
    { title: "Welsh", ingredients: "Jambon blanc, Cheddar, Œuf, Mozzarella, Emmental, Olives noires", price: 12.50, position: 3 },
    { title: "Curry", ingredients: "Filet de poulet, Pomme de terre, Poivron, Mozzarella, Emmental, Olives noires", price: 12.50, position: 4 },
    { title: "Carbonara", ingredients: "Lardons fumés, Champignon blanc, Parmesan, Oignon, Œuf, Mozzarella, Emmental, Olives noires", price: 12.50, position: 5 },
    { title: "Zapiekanka (Polonaise)", ingredients: "Metka, Pomme de terre, Oignons, Ketchup, Mozzarella, Emmental, Olives noires", price: 13.00, position: 6 },
    { title: "Biquette", ingredients: "Chèvre, Miel, Noix, Thym, Mozzarella, Emmental, Olives noires", price: 12.00, position: 7 },
    { title: "Normande", ingredients: "Camembert, Lardons fumés, Oignons, Mozzarella, Emmental, Olives noires", price: 12.50, position: 8 },
    { title: "Forestière", ingredients: "Champignon blanc, Lardons fumés, Oignons, Mozzarella, Emmental, Olives noires", price: 12.00, position: 9 },
    { title: "Raclette", ingredients: "Jambon blanc, Chorizo, Fromage à raclette, Pomme de terre, Jambon cru, Mozzarella, Emmental, Olives noires", price: 14.00, position: 10 }
  ]
)

boissons = card_menu.card_menu_categories.create!(
  title: "Supplément",
  position: 3,
  card_menu_items_attributes: [
    { title: "Ingrédient supplémentaire", price: 2.00, position: 1 }
  ]
)
