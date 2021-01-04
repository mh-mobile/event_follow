import { defineNuxtMiddleware } from "@nuxtjs/composition-api"
import "firebase/auth"

export default defineNuxtMiddleware(({ store, route, redirect }) => {
  if (!store.state.auth && route.name === "events") {
    return redirect("/home")
  }

  if (!store.state.auth && route.name === "index") {
    return redirect("/home")
  }

  if (store.state.auth && route.name !== "events") {
    return redirect("/events")
  }
})
