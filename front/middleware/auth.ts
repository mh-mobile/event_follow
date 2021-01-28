import { defineNuxtMiddleware } from "@nuxtjs/composition-api"
import "firebase/auth"
import { state } from "~/store"

export default defineNuxtMiddleware(({ store, route, redirect }) => {
  if (!store.state.auth && route.name !== "home") {
    return redirect("/home")
  }

  if (!store.state.auth) {
    return redirect("/home")
  }

  if (route.name === "settings" || route.name === "events") {
    return
  }

  return redirect("/events")
})
