<template lang="pug">
.home_twitter_login
  .twitter_login_button(@click="loginByTwitter")
    | Twitterで始める
</template>

<script lang="ts">
import { defineComponent, useContext } from "@nuxtjs/composition-api"
import firebase from "firebase/app"
import "firebase/auth"
const Cookie = process.client ? require("js-cookie") : undefined

export default defineComponent({
  setup(props, { root }) {
    if (process.server) {
      return
    }
    const { store } = useContext()

    const loginByTwitter = () => {
      const provider = new firebase.auth.TwitterAuthProvider()
      firebase
        .auth()
        .signInWithPopup(provider)
        .then(async (result) => {
          if (result == null) return
          const credential = result.credential as firebase.auth.OAuthCredential
          if (credential == null) return
          const token = credential.accessToken
          const secret = credential.secret
          const user = result.user
          if (token == null || secret == null || user == null) return
          const id_token = await user.getIdToken()
          root.$axios
            .post("/api/sessions", {
              access_token: token,
              access_token_secret: secret,
              token: id_token
            })
            .then(() => {
              const auth = {
                id_token
              }

              store.commit("setAuth", auth)
              Cookie.set("auth", auth)
              root.$router.replace("/events")
            })
            .catch((error) => {
              console.log(`error: ${error}`)
            })
        })
        .catch(function (error) {
          console.log(`error: ${error}`)
        })
    }

    return {
      loginByTwitter
    }
  }
})
</script>

<style lang="scss" scoped>
.home_twitter_login {
  width: 100%;
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;

  .twitter_login_button {
    background: #218af5;
    color: #fff;
    font-size: 1em;
    font-weight: bold;
    padding: 15px 40px;
    border-radius: 10px;
    cursor: pointer;

    &::before {
      content: "";
      display: inline-block;
      width: 40px;
      height: 40px;
      background-image: url("~@/assets/twitter_logo.png");
      background-size: contain;
      vertical-align: middle;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
