export default {
  // Global page headers (https://go.nuxtjs.dev/config-head)
  head: {
    title: "Event Follow",
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { hid: "description", name: "description", content: "興味のある技術イベントを見逃さない" },
      { hid: "keywords", name: "keywords", content: "イベント,IT勉強会,技術イベント,EVENT FOLLOW,イベントフォロー,doorkeeper,connpass" },
      { hid: "og:type", name: "og:type", content: "website" },
      { hid: "og:url", name: "og:url", content: "https://eventfollow.app" },
      { hid: "og:title", name: "og:title", content: "EVENT FOLLOW" },
      { hid: "og:description", name: "og:description", content: "興味のある技術イベントを見逃さない" },
      { hid: "og:image", name: "og:image", content: "https://eventfollow.app/ogp_banner.png" },
      { hid: "twitter:card", name: "twitter:card", content: "summary_large_image" },
      { hid: "twitter:url", name: "twitter:url", content: "https://eventfollow.app" },
      { hid: "twitter:title", name: "twitter:title", content: "EVENT FOLLOW" },
      { hid: "twitter:description", name: "twitter:description", content: "興味のある技術イベントを見逃さない" },
      { hid: "twitter:image", name: "twitter:image", content: "https://eventfollow.app/ogp_banner.png" },
    ],
    link: [
      { rel: "icon", type: "image/x-icon", href: "/favicon.ico" },
      { rel: "stylesheet", href: "https://cdn.jsdelivr.net/npm/yakuhanjp@3.3.1/dist/css/yakuhanjp.min.css" }
    ]
  },
  loading: {
    color: "#0099e5",
    continuous: true,
    height: "5px"
  },

  // Global CSS (https://go.nuxtjs.dev/config-css)
  css: [],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [
    { src: "~/plugins/firebase.ts" },
    { src: "~/plugins/firebase-auth.ts", mode: "client" }
  ],
  mode: "universal",
  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Middleware
  router: {
    middleware: ["auth"]
  },

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
    // https://go.nuxtjs.dev/typescript
    "@nuxt/typescript-build",
    "@nuxtjs/composition-api",
    "@nuxtjs/device",
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
    // https://go.nuxtjs.dev/bootstrap
    "@nuxtjs/bulma",
    "@nuxtjs/axios",
    "@nuxtjs/sentry",
  ],
  proxy: {
    "/api/": {
      target: process.env.API_URL,
      pathRewrite: {
        "^/api": "/api"
      }
    }
  },
  axios: {
    proxy: true
  },

  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {
    postcss: {
      preset: {
        features: {
          customProperties: false
        }
      }
    }
  },
  env: {
    FIREBASE_API_KEY: process.env.FIREBASE_API_KEY,
    FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN,
    FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
    FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET,
    FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID,
    FIREBASE_APP_ID: process.env.FIREBASE_APP_ID,
    FIREBASE_MEASUREMENT_ID: process.env.FIREBASE_MEASUREMENT_ID
  },
  storybook: {
    addons: [
      "@storybook/addon-actions/register",
      "@storybook/addon-controls/register",
      "@storybook/addon-toolbars/register",
      "@storybook/addon-viewport/register"
    ],
    parameters: {
      backgrounds: {
        default: "white",
        values: [
          { name: "white", value: "#ffffff" },
          { name: "gray", value: "#aaaaaa" }
        ]
      }
    }
  }
}
