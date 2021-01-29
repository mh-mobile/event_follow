<template lang="pug">
  div
    .account-deletion-button(@click="openModal")
      | 退会
    Modal(@close="closeModal" v-if="modal")
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
</style>
