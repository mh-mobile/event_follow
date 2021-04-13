<template lang="pug">
  div
    .account-deletion-button(@click="openModal")
      | 退会
    Modal(@close="closeModal" v-if="modal")
      .modal-container
        .title-container
          .title
            | 退会してもよろしいですか？
        .button-container
          .cancel-button(@click="closeModal")
            | キャンセル
          .ok-button(@click="deleteAccount")
            | 退会する
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
      modal: false,
      deleteAccount: null
    })

    if (process.server) {
      return {
        ...toRefs(state),
        deleteAccount: null
      }
    }

    const { store } = useContext()

    const logout = () => {
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

    const requestUsersAPI = async (idToken: string) => {
      root.$nuxt.$loading.start()
      root.$axios
        .delete("/api/users", {
          headers: {
            Authorization: `Bearer ${idToken}`
          }
        })
        .then(() => {
          root.$nuxt.$loading.finish()
          logout()
        })
        .catch((error) => {
          root.$nuxt.$loading.finish()
          root.$sentry.captureException(error)
          if (error.response.status === 401) {
            logout()
          }
        })
    }

    const deleteAccount = async () => {
      const currentUser = firebase.auth().currentUser
      if (currentUser == null) return
      const idToken = await currentUser.getIdToken()
      requestUsersAPI(idToken)
    }

    const { setScrollEnabled } = useModalHelper()

    const openModal = () => {
      state.modal = true
      setScrollEnabled(false)
    }

    const closeModal = () => {
      state.modal = false
      setScrollEnabled(true)
    }

    return {
      ...toRefs(state),
      deleteAccount,
      openModal,
      closeModal
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

@media all and (min-width: 480px) {
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

      .cancel-button {
        width: 200px;
        height: 44px;
        background: #878787;
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
}

@media all and (max-width: 480px) {
  .modal-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
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
      flex-direction: column;
      align-items: center;
      justify-content: center;
      margin-top: 40px;

      .ok-button {
        width: 250px;
        height: 44px;
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
        margin-top: 10px;

        &:hover {
          opacity: 0.8;
        }
      }

      .cancel-button {
        width: 250px;
        height: 44px;
        background: #878787;
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
    }
  }
}
</style>
