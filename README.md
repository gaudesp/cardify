# Cardify

**Description**  
Cardify est un SaaS de cartes de visite digitales, construit avec Rails API-only et React, permettant de créer, gérer et publier une présentation en ligne simple, modulaire et élégante.

## Source of Truth

Ce README est la **source de vérité** du projet Cardify.  
Il regroupe **toutes** les décisions validées : vision produit, périmètre MVP, modèles, tables, JSON, API admin/public/auth, séparation des espaces, UX admin, architecture frontend, règles de scalabilité.

## 1) Vision & concept

Cardify est un **SaaS de création de cartes de visite digitales** (pas un site builder).

Une carte de visite digitale Cardify :
- représente une **entité** (personne, créateur, commerce, étudiant, marque, artisan, foodtruck…)
- reste **simple, claire, rapide**
- repose sur une structure stable :
  - **Navbar** : naviguer entre pages
  - **Aside** : résumé + identité + actions + réseaux
  - **Page** : contenu modulaire (une page → des modules)

Objectif produit :
- permettre à n’importe qui de créer une **présentation digitale moderne** en quelques minutes, sans compétence technique
- être scalable via ajout de nouveaux types de modules

## 2) Cibles

Cible élargie (non limitée aux artisans/commerçants) :
- Streamer / YouTubeur / créateur
- CV / portfolio (étudiant, recherche d’emploi)
- Freelance / indépendant
- Artisans / foodtruck / commerçants / marques
- Toute personne cherchant de la visibilité

## 3) Périmètre MVP (V1)

### 3.1 Auth (MVP)
- Inscription
- Connexion
- Session JWT

### 3.2 Site (carte de visite)
- Un user peut créer 0..n sites
- Un site contient :
  - **Thème (obligatoire)** :
    - background_color*
    - color_primary*
    - color_secondary*
    - color_text*
  - **Aside** :
    - image upload (optionnel)
    - title*
    - description*
    - réseaux sociaux (optionnel)
    - actions (MVP) :
      - contacter par email
      - appeler par numéro
  - **Pages** : 0..n pages, ordonnées
  - **Modules** : 0..n modules par page, ordonnés
  - Publication : `published` (brouillon/public)

Champs obligatoires marqués `*`. Le reste est optionnel.

### 3.3 Modules (V1)
- Un seul type en V1 : **TEXT**
  - title*
  - icon
  - content* (markdown, rendu côté frontend)
  - description

## 4) Séparation des espaces (layouts) — validé

Trois espaces, nets, lisibles :

### 4.1 Marketing (`/`)
- Landing page SaaS
- Sections scrollables : concept, fonctionnalités, “ils nous font confiance”, etc.
- Navbar avec actions à droite (dropdown selon état auth) :
  - non connecté : login / register
  - connecté : dashboard / settings / logout

### 4.2 Admin (`/admin/:siteId`)
- Backoffice (auth obligatoire)
- Gérer :
  - site (identity/theme/publish/image)
  - pages (CRUD + ordre)
  - social_links (CRUD + ordre)
  - cards (CRUD + ordre)

### 4.3 Public (`/:slug`)
- Affichage public en lecture seule
- Aucune action backoffice
- Rendu à partir d’un JSON agrégé

## 5) Stack technique — validé

### Backend
- Ruby on Rails **API-only**
- PostgreSQL
- JWT (auth stateless)
- ActiveStorage (image aside)
- JSONB (thème + settings extensibles)
- STI pour les modules (Card)
- Markdown stocké brut (rendu côté React)
- ActionText : **NON** (trop view-coupled, HTML serveur inutile en API-only)

### Frontend
- React
- Vite
- Tailwind CSS
- React Router
- Pas de store global en V1 (state local suffisant)
- Markdown rendu côté client

## 6) Modèle métier (V1) — entités & relations

### 6.1 User
- has_many :sites, dependent: :destroy

### 6.2 Site
Relations :
- belongs_to :user
- has_many :pages, -> { order(:position) }, dependent: :destroy
- has_many :social_links, dependent: :destroy
- has_one_attached :aside_image

Champs métier :
- title* (nom affiché : personne/marque/commerce)
- description* (aside)
- slug* (URL public)
- phone_number (action)
- contact_email (action)
- published (bool)
- setting.theme :
  - background_color*
  - color_primary*
  - color_secondary*
  - color_text*

### 6.3 SocialLink
- belongs_to :site
- platform*
- url*
- position

### 6.4 Page
- belongs_to :site
- acts_as_list scope: :site
- has_many :cards, -> { order(:position) }, inverse_of: :page, dependent: :destroy

Champs :
- label* (navbar label)
- icon
- slug*
- position

### 6.5 Card (STI)
- belongs_to :page
- acts_as_list scope: :page
- type* (ex: CardContent)
- title*
- icon
- description
- position
- setting (jsonb extensible)

### 6.6 CardContent < Card (V1)
- content* (text) = markdown brut

Anticipation :
- CardMenu, CardGallery, CardVideo, CardLinks, CardContact, etc.

## 7) Tables / schéma DB (V1) — colonnes validées

IDs UUID recommandés. Positions gérées serveur via acts_as_list.

### 7.1 sites
    t.uuid     :user_id, null: false
    t.string   :title, null: false
    t.text     :description, null: false
    t.string   :slug, null: false
    t.string   :phone_number
    t.string   :contact_email
    t.boolean  :published, default: false
    t.jsonb    :setting, default: {
      "theme" => {
        "background_color" => "#323232",
        "color_primary": "#86d17c",
        "color_secondary": "#50a2a1",
        "color_text": "#646464"
      }
    }
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false

### 7.2 social_links
    t.uuid     :site_id, null: false
    t.string   :platform, null: false
    t.string   :url, null: false
    t.integer  :position
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false

### 7.3 pages
    t.uuid     :site_id, null: false
    t.string   :label, null: false
    t.string   :slug, null: false
    t.string   :icon
    t.integer  :position
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false

### 7.4 cards (STI)
    t.uuid     :page_id, null: false
    t.string   :title, null: false
    t.text     :description
    t.string   :icon
    t.string   :type, null: false
    t.integer  :position
    t.jsonb    :setting, default: {}
    t.text     :content                # utilisé par CardContent (markdown)
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false

### 7.5 ActiveStorage (Rails)
- active_storage_blobs
- active_storage_attachments

## 8) Exemple de données (V1) — cohérent bout en bout

### 8.1 User
    {
      "id": "user_1",
      "email": "gauthier@example.com"
    }

### 8.2 Site
    {
      "id": "site_1",
      "user_id": "user_1",
      "title": "Gauthier Desplanque",
      "description": "Développeur web full stack spécialisé Ruby on Rails & React.",
      "slug": "gauthier-desplanque",
      "phone_number": "+33600000000",
      "contact_email": "contact@gaudesp.fr",
      "published": true,
      "setting": {
        "theme": {
          "background_color": "#323232",
          "color_primary": "#86d17c",
          "color_secondary": "#50a2a1",
          "color_text": "#646464"
        }
      }
    }

### 8.3 SocialLinks
    [
      {
        "site_id": "site_1",
        "platform": "github",
        "url": "https://github.com/gaudesp",
        "position": 1
      },
      {
        "site_id": "site_1",
        "platform": "linkedin",
        "url": "https://linkedin.com/in/gauthierdesplanque",
        "position": 2
      }
    ]

### 8.4 Pages
    [
      {
        "id": "page_1",
        "site_id": "site_1",
        "label": "À propos",
        "slug": "about",
        "icon": "user",
        "position": 1
      },
      {
        "id": "page_2",
        "site_id": "site_1",
        "label": "Projets",
        "slug": "projects",
        "icon": "folder",
        "position": 2
      }
    ]

### 8.5 Cards (CardContent)
    [
      {
        "id": "card_1",
        "page_id": "page_1",
        "type": "CardContent",
        "title": "Qui suis-je ?",
        "description": "Quelques mots sur moi...",
        "icon": "user",
        "position": 1,
        "content": "Développeur passionné avec 8 ans d'expérience..."
      },
      {
        "id": "card_2",
        "page_id": "page_2",
        "type": "CardContent",
        "title": "Cardify & NoxTools",
        "description": "Mes dernières réalisations...",
        "icon": "code",
        "position": 1,
        "content": "- Cardify : carte de visite digitale\n- NoxTools : plateforme créative"
      }
    ]

## 9) Auth (JWT) — validé

### 9.1 Choix
- JWT stateless
- adapté API-only + React

### 9.2 Endpoints
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout (optionnel : discard token côté frontend)
- GET  /api/auth/me

### 9.3 Payloads & réponse

Register :

    { "email": "user@example.com", "password": "secret123" }

Login :

    { "email": "user@example.com", "password": "secret123" }

Response :

    {
      "token": "jwt_token_here",
      "user": { "id": "user_1", "email": "user@example.com" }
    }

## 10) Conventions API — validé

- Admin : /api/admin/** (JWT obligatoire)
- Public : /api/public/** (sans auth)
- positions gérées serveur (acts_as_list)
- Card en STI : `type` requis
- V1 : CardContent uniquement (modules texte)

## 11) API ADMIN V1 — Pages & Cards (contrats définitifs)

### 11.1 Pages (sidebar)

List pages :
GET /api/admin/sites/:site_id/pages

    {
      "pages": [
        { "id": "p1", "label": "À propos", "icon": "user", "slug": "about", "position": 1 },
        { "id": "p2", "label": "Projets", "icon": "folder", "slug": "projects", "position": 2 }
      ]
    }

Create page :
POST /api/admin/sites/:site_id/pages

Request :

    { "label": "À propos", "icon": "user" }

Response :

    { "id": "p1", "label": "À propos", "icon": "user", "slug": "about", "position": 1 }

Update page :
PATCH /api/admin/pages/:id

    { "label": "Projets", "icon": "folder" }

Delete page :
DELETE /api/admin/pages/:id  → 204

Move page :
PATCH /api/admin/pages/:id/move

Request :

    { "direction": "up" }   (ou "down")

Response :

    { "id": "p2", "position": 1 }

### 11.2 Cards (modules de la page active)

List cards :
GET /api/admin/pages/:page_id/cards

    {
      "cards": [
        {
          "id": "c1",
          "type": "CardContent",
          "title": "Qui suis-je ?",
          "description": "Quelques mots sur moi...",
          "icon": "user",
          "position": 1,
          "content": "Markdown..."
        }
      ]
    }

Create card (TEXT only V1) :
POST /api/admin/pages/:page_id/cards

Request :

    {
      "type": "CardContent",
      "title": "Mon parcours",
      "description": "Plus d'informations sur mon parcours...",
      "icon": "newspaper",
      "content": "Markdown..."
    }

Response :

    {
      "id": "c2",
      "type": "CardContent",
      "title": "Mon parcours",
      "description": "Plus d'informations sur mon parcours...",
      "icon": "newspaper",
      "position": 2,
      "content": "Markdown..."
    }

Update card :
PATCH /api/admin/cards/:id

    { "title": "Mon parcours", "description": "Plus d'informations sur mon parcours...", "icon": "newspaper", "content": "Markdown mis à jour" }

Delete card :
DELETE /api/admin/cards/:id  → 204

Move card :
PATCH /api/admin/cards/:id/move

Request :

    { "direction": "down" } (ou "up")

Response :

    { "id": "c1", "position": 2 }

## 12) API ADMIN V1 — Site settings (contrats définitifs)

Get site (pour admin panel) :
GET /api/admin/sites/:id

    {
      "id": "site_1",
      "title": "Gauthier Desplanque",
      "description": "Développeur web full stack",
      "slug": "gauthier-desplanque",
      "phone_number": "+33600000000",
      "contact_email": "contact@gaudesp.fr",
      "published": false,
      "aside_image_url": "https://cdn.cardify.io/aside.jpg",
      "setting": {
        "theme": {
          "background_color": "#323232",
          "color_primary": "#86d17c",
          "color_secondary": "#50a2a1",
          "color_text": "#646464"
        }
      }
    }

Update identity :
PATCH /api/admin/sites/:id/identity

    {
      "title": "Gauthier Desplanque",
      "description": "Développeur web full stack",
      "phone_number": "+33600000000",
      "contact_email": "contact@gaudesp.fr"
    }

Upload aside image :
PATCH /api/admin/sites/:id/aside_image
multipart/form-data, key: aside_image

Response :

    { "aside_image_url": "https://cdn.cardify.io/aside.jpg" }

Update theme :
PATCH /api/admin/sites/:id/theme

    {
      "background_color": "#ffffff",
      "color_primary": "#4f46e5",
      "color_secondary": "#22c55e",
      "color_text": "#111827"
    }

Publish / Unpublish :
PATCH /api/admin/sites/:id/publish

Request :

    { "published": true }

Response :

    { "published": true, "public_url": "https://cardify.io/gauthier-desplanque" }

Delete site :
DELETE /api/admin/sites/:id → 204

## 13) API PUBLIC V1 — JSON agrégé (contrat définitif)

Endpoint :
GET /api/public/sites/:slug

Réponse (sans IDs) :

    {
      "site": {
        "title": "Gauthier Desplanque",
        "description": "Développeur web full stack spécialisé Ruby on Rails & React",
        "aside_image_url": "https://cdn.cardify.io/aside.jpg",
        "actions": {
          "email": "contact@gaudesp.fr",
          "phone": "+33600000000"
        },
        "theme": {
          "background_color": "#323232",
          "color_primary": "#86d17c",
          "color_secondary": "#50a2a1",
          "color_text": "#646464"
        },
        "social_links": [
          { "platform": "github", "url": "https://github.com/gaudesp" },
          { "platform": "linkedin", "url": "https://linkedin.com/in/gauthierdesplanque" }
        ]
      },
      "navigation": [
        { "label": "À propos", "icon": "user", "slug": "about" },
        { "label": "Projets", "icon": "folder", "slug": "projects" }
      ],
      "pages": [
        {
          "slug": "about",
          "modules": [
            {
              "type": "CardContent",
              "title": "Qui suis-je ?",
              "description": "Quelques mots sur moi...",
              "icon": "user",
              "content": "Développeur..."
            }
          ]
        },
        {
          "slug": "projects",
          "modules": [
            {
              "type": "CardContent",
              "title": "Cardify & NoxTools",
              "description": "Mes dernières réalisations...",
              "icon": "code",
              "content": "- Cardify...\n- NoxTools..."
            }
          ]
        }
      ]
    }

Règles :
- aucun ID exposé
- navigation = source unique navbar
- pages.slug = mapping
- modules ordonnés
- type = switch UI
- markdown rendu côté React
- cache-friendly et extensible

## 14) Admin UX (détails) — validé

Principe :
- l’utilisateur ne “construit pas un site”
- il remplit une **carte de visite**
- l’admin doit être “bête mais clair”, la magie viendra plus tard

Layout (3 colonnes) :
- Sidebar : pages
- Centre : modules de la page active
- Droite : settings site (tabs identity/theme/publish)

Décision clé :
- une seule page active à la fois (réduit 90% de la complexité)

## 15) Frontend architecture (V1) — validé

### 15.1 Routing
    /
    /login
    /register
    /dashboard
    /admin/:siteId
    /admin/:siteId?page=:id
    /:slug   (en dernier)

### 15.2 Layouts React
- MarketingLayout
- AdminLayout
- PublicLayout

### 15.3 Pages React
- marketing/HomePage
- auth/LoginPage
- auth/RegisterPage
- dashboard/DashboardPage
- admin/SiteEditorPage
- public/PublicSitePage

### 15.4 Composants Admin
- PagesSidebar, PageRow, AddPageButton
- PageModulesPanel, ModulesList, ModuleRow
- ModuleEditorDrawer
- SiteSettingsPanel :
  - IdentityForm
  - ThemeForm
  - PublishPanel

### 15.5 Composants Public
- Navbar
- Aside
- PageRenderer
- modules/CardContent

### 15.6 State management (V1)
- local state (useState/useEffect)
- fetch simple
- page active pilotée par query param `page` (URL stable)

## 16) Hors scope V1 (verrouillé)

- pas de drag & drop
- pas de preview live
- pas de mobile-first (mais structure HTML anticipée)
- pas de collaboration
- pas de permissions avancées
- pas de templates
- pas de FSD strict (feature-based simple)

## 17) Scalabilité (verrouillée)

Pourquoi c’est scalable :
- STI sur Card → nouveaux modules sans casser l’existant
- `setting` jsonb extensible
- positions gérées serveur
- API admin stable (type requis)
- JSON public stable, cache-friendly

## 18) Décisions finales “non négociables” (verrouillées)

- Rails API-only + JWT + Postgres + ActiveStorage + JSONB + STI
- React + Vite + Tailwind
- Espaces : marketing `/`, admin `/admin/:siteId`, public `/:slug`
- Admin : éditeur linéaire 3 colonnes (pages / modules / settings)
- V1 : module TEXT uniquement, markdown brut rendu côté React
- API admin : /api/admin
- API public : /api/public
- Contrats API Pages/Cards/Site settings/Public JSON = Source of Truth
