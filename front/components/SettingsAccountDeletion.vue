<template lang="pug">
  .account-deletion-button(@click="deleteAccount")
    | 退会
</template>

<script lang="ts">
import { defineComponent, useContext } from "@nuxtjs/composition-api"

import firebase from "firebase/app"
import "firebase/auth"
const Cookie = process.client ? require("js-cookie") : undefined

export default defineComponent({
  setup(props, { root }) {
    if (process.server) {
      return {
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

    return {
      deleteAccount
    }
  }
})
</script>

<style lang="scss" scoped>
.account-deletion-button {
  width: 200px;
  background: #ff5454;
  color: #fff;
  font-size: 1em;
  font-weight: bold;
  padding: 15px 40px;
  border-radius: 10px;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;

  &:hover {
    opacity: 0.8;
  }
}
</style>
