<template lang="pug">
div
  .setting_continue
</template>

<script lang="ts">
import {
  defineComponent,
  onUnmounted,
  onMounted,
  useContext
} from "@nuxtjs/composition-api"
import { useProfileSettings } from "@/compositions/profile_settings"

import firebase from "firebase/app"
import "firebase/auth"
const Cookie = process.client ? require("js-cookie") : undefined

declare global {
  interface Window {
    twttr: any
  }
}

export default defineComponent({
  layout: "authorized_default",
  setup(props, { root }) {
    if (process.server) {
      return {
        currentUser: null,
        deleteAccount: null
      }
    }

    const { store } = useContext()

    const deleteAccount = () => {
      root.$nuxt.$loading.start()
      firebase
        .auth()
        .signOut()
        .then(() => {
          store.commit("setAuth", null)
          Cookie.remove("auth")
          root.$nuxt.$loading.finish()
          window.location.href = "/home"
        })
    }

    const { showProfileSettings, hideProfileSettings } = useProfileSettings()

    onMounted(() => {
      root.$nextTick(() => {
        showProfileSettings()
      })
    })

    onUnmounted(() => {
      hideProfileSettings()
    })

    return {
      deleteAccount
    }
  }
})
</script>

<style lang="scss" scoped>
.settings_container {
  max-width: 50rem;
  min-width: 50rem;
  margin: 0 auto;
  margin-top: 20px;
  margin-bottom: 20px;
  padding: 20px 30px;
  background-color: orange;
  border-radius: 5px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}
</style>
