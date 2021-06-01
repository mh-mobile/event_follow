const cookieParser = process.server ? require("cookieparser") : undefined
import { useCookieCryptoHelper } from "@/compositions/cookie_crypto_helper"

export const state = () => ({
  auth: null
})

export const mutations = {
  setAuth(state: { auth: string }, auth: string) {
    state.auth = auth
  }
}

export const actions = {
  nuxtServerInit(
    { commit }: { commit: any },
    { req, $sentry, $config }: { req: any; $sentry: any, $config: any }
  ) {
    let auth = null
    if (req.headers.cookie) {
      const parsed = cookieParser.parse(req.headers.cookie)
      try {
        const { decryptCookieValue } = useCookieCryptoHelper()
        auth = JSON.parse(decryptCookieValue(parsed.auth, $config.cookieSecret))
      } catch (error) {
        $sentry.captureException(error)
      }
    }
    commit("setAuth", auth)
  }
}
