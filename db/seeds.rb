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
)

site.aside_image.attach(
  io: File.open(Rails.root.join("db/seeds/images/aside.jpg")),
  filename: "aside.jpg",
  content_type: "image/jpeg"
)

site.social_links.create!([
  { platform: "instagram", url: "https://instagram.com/...", position: 1 },
  { platform: "facebook",  url: "https://facebook.com/...",  position: 2 },
  { platform: "tiktok",    url: "https://tiktok.com/...",    position: 3 },
  { platform: "youtube",   url: "https://youtube.com/...",   position: 4 },
  { platform: "whatsapp",  url: "https://wa.me/...",         position: 5 }
])

page1 = Page.create!(
  site: site,
  title: "A propos",
  label: "info",
  icon: "info-circle",
  position: 1
)

page2 = Page.create!(
  site: site,
  title: "Notre carte",
  label: "menu",
  icon: "utensils",
  position: 2
)

CardContent.create!(
  page: page1,
  position: 1,
  content: """
  <p>
  Arancinis croustillants, tiramisus maison, panettones artisanaux… Ici, tout est préparé avec passion, à partir de produits de qualité et d’un savoir-faire transmis avec le cœur.
  </p>

  <p>
  Inspirée des traditions siciliennes et pensée pour la rue, cette cuisine voyage de marché en marché, d’événement en événement, pour vous offrir une pause gourmande, conviviale et authentique.
  </p>

  <p>
  Sur place ou à emporter, pour un déjeuner rapide ou une fête entre amis, chaque bouchée raconte une histoire : celle de la générosité, du goût, et du plaisir simple de bien manger.
  </p>

  <p>
  Découvrez le menu, suivez le camion… et laissez-vous surprendre 🍽️
  </p>
  """
)

CardContent.create!(
  page: page2,
  position: 1,
  content: """
  <h3>🍽️ Arancini</h3>
  <ul>
    <li><strong>Arancini</strong> <em>(bolo, poulet, mortadelle, végé, thon)</em> — <strong>4,50 €</strong></li>
    <li><strong>Arancini Piccolo</strong> <em>(bolo, poulet, mortadelle, végé, thon)</em> — <strong>2,50 €</strong></li>
  </ul>

  <h3>🍰 Desserts</h3>
  <ul>
    <li><strong>Tiramisu</strong> <em>(café, speculoos, chocolat blanc, nutella)</em> — <strong>3,50 €</strong></li>
    <li><strong>Panettone</strong> 100 gr <em>(en supp pour formule)</em> — <strong>5,00 €</strong></li>
    <li><strong>Panettone</strong> boîte métal 750 gr — <strong>28,00 €</strong></li>
  </ul>

  <h3>🥤 Boissons</h3>
  <ul>
    <li>Limonade de Sicile, San Pellegrino — <strong>1,50 €</strong></li>
    <li>Bière italienne — <strong>3,50 €</strong></li>
    <li>Chianti 37,5 cl — <strong>5,50 €</strong></li>
    <li>Chianti 50 cl — <strong>6,90 €</strong></li>
  </ul>
  """
)
