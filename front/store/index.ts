const cookieParser = process.server ? require("cookieparser") : undefined

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
    { req, $sentry }: { req: any; $sentry: any }
  ) {
    let auth = null
    if (req.headers.cookie) {
      const parsed = cookieParser.parse(req.headers.cookie)
      try {
        auth = JSON.parse(parsed.auth)
      } catch (error) {
        $sentry.captureException(error)
      }
    }
    commit("setAuth", auth)
  }
}
