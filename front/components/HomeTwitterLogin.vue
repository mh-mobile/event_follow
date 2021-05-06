<template lang="pug">
div
  .home_twitter_login
    .twitter_login_button(@click="loginByTwitter")
      | Twitterで始める
    .twitter_agreement
      .agreement_upper
        | アカウントを作成することで
        a(href="/terms")
          | 利用規約
        |・
      .agreement_lower
        a(href="/privacy_policy")
          | プライバシーポリシー
        | に同意したものとみなします。
  Modal(@close="closeModal" v-if="modal")
    .modal-container
      .title-container
        .title
          | ログインできませんでした。
      .button-container
        .ok-button(@click="closeModal")
          | OK 

</template>

<script lang="ts">
import {
  defineComponent,
  useContext,
  reactive,
  toRefs
} from "@nuxtjs/composition-api"
import Modal from "@/components/Modal.vue"
import { useModalHelper } from "@/compositions/modal_helper"
import firebase from "firebase/app"
import "firebase/auth"
const Cookie = process.client ? require("js-cookie") : undefined

export default defineComponent({
  components: { Modal },
  setup(props, { root }) {
    const state = reactive({
      modal: false
    })
    if (process.server) {
      return {
        ...toRefs(state)
      }
    }
    const { store } = useContext()

    const { setScrollEnabled } = useModalHelper()
    const openModal = () => {
      state.modal = true
      setScrollEnabled(false)
    }
    const closeModal = () => {
      state.modal = false
      setScrollEnabled(true)
    }

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
              root.$sentry.captureException(error)
            })
        })
        .catch(function (error) {
          root.$sentry.captureException(error)
          openModal()
        })
    }

    return {
      ...toRefs(state),
      loginByTwitter,
      openModal,
      closeModal
    }
  }
})
</script>

<style lang="scss" scoped>
.home_twitter_login {
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  @media all and (min-width: 480px) {
    .twitter_login_button {
      background: #218af5;
      color: #fff;
      font-size: 1em;
      font-weight: bold;
      padding: 15px 40px;
      border-radius: 10px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 360px;

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

  @media all and (max-width: 480px) {
    .twitter_login_button {
      background: #218af5;
      color: #fff;
      font-size: 1em;
      font-weight: bold;
      padding: 10px 30px;
      border-radius: 10px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;

      &::before {
        content: "";
        display: inline-block;
        width: 30px;
        height: 30px;
        background-image: url("~@/assets/twitter_logo.png");
        background-size: contain;
        vertical-align: middle;
      }

      &:hover {
        opacity: 0.8;
      }
    }
  }

  .twitter_agreement {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    margin-top: 5px;

    .agreement_upper {
      font-size: 0.8em;
    }

    .agreement_lower {
      margin-top: 2px;
      font-size: 0.8em;
    }
  }
}

.modal-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-width: 30em;
  padding: 20px;
  .title-container {
    display: flex;
    align-items: center;
    justify-content: center;
    .title {
      color: #000000;
      font-size: 1em;
      font-weight: normal;
    }
  }
  .button-container {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;

    .ok-button {
      width: 200px;
      height: 44px;
      background: #218af5;
      color: #fff;
      font-size: 1em;
      font-weight: bold;
      padding: 15px 40px;
      border-radius: 10px;
      cursor: pointer;
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 20px;
      &:hover {
        opacity: 0.8;
      }
    }
  }
}
</style>
