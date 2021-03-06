<template lang="pug">
  div
    .header
      .header-container
        .logo
          nuxt-link(to="/events")
            img(src="@/assets/logo_transparent.png")
        client-only
          .profile
            #js-profile.profile_icon(v-if="currentUser")
              img.profile_image(:src="currentUser.photoURL")
            ul.profile_setting#js-profile-setting(v-show="currentUser")
              li.profile_setting_item(v-if="currentUser")
                | {{ currentUser.displayName }}
              li.profile_setting_item
                a(href="#" @click="goToSetting")
                  | 設定
              li.profile_setting_item
                a(href="#" @click="logout")
                  | ログアウト
    Nuxt
</template>

<script lang="ts">
import { defineComponent, useContext } from "@nuxtjs/composition-api"
import { useCurrentUser } from "@/compositions/user"

import firebase from "firebase/app"
import "firebase/auth"
const Cookie = process.client ? require("js-cookie") : undefined

export default defineComponent({
  setup(props, { root }) {
    if (process.server) {
      return {
        currentUser: null,
        logout: null,
        deleteAccount: null,
        goToSetting: null,
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

    const goToSetting = () => {
      window.location.href = "/settings"
    }

    const { currentUser } = useCurrentUser()

    return {
      currentUser,
      logout,
      goToSetting
    }
  }
})
</script>

<style lang="scss">
html {
  background-color: #d7d7d8;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

body {
  background-color: #d7d7d8;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;

  a {
    color: #004276;
    &:hover {
      color: rgba(0, 66, 118, 0.8);
    }
  }
}

.scroll_disable {
  overflow: hidden;
}

@media all and (min-width: 480px) {
  .header {
    padding: 0 5px;
    background-color: #efe9e5;

    .header-container {
      max-width: 50rem;
      margin: 0 auto;
      padding: 0 5px;
      height: 64px;
      display: flex;
      flex-direction: row;
      align-items: center;
      justify-content: flex-end;
      box-sizing: border-box;
      -moz-box-sizing: border-box;
      -webkit-box-sizing: border-box;
      position: relative;

      .logo {
        margin-right: auto;
        height: 48px;

        a {
          display: flex;
          flex-direction: row;
          align-items: center;

          img {
            display: flex;
            flex-direction: row;
            align-items: center;
            height: 48px;
          }
        }
      }

      .profile {
        .profile_icon {
          width: 48px;
          height: 48px;
          overflow: hidden;
          border-radius: 50%;
          cursor: pointer;
          &:hover {
            opacity: 0.8;
          }
        }

        .profile_setting {
          display: none;
          background-color: #fff;
          width: 240px;
          padding: 10px 30px;
          border: 1px solid #ccc;
          position: absolute;
          top: 64px;
          right: 0;
          z-index: 2;
          border-radius: 0 0 5px 5px;

          .profile_setting_item {
            &:not(:last-child) {
              padding-bottom: 5px;
            }
          }
        }
      }
    }
  }
}

@media all and (max-width: 480px) {
  .header {
    background-color: #efe9e5;

    .header-container {
      margin: 0 auto;
      padding: 0 20px;
      height: 56px;
      display: flex;
      flex-direction: row;
      align-items: center;
      justify-content: flex-end;
      box-sizing: border-box;
      -moz-box-sizing: border-box;
      -webkit-box-sizing: border-box;
      position: relative;

      .logo {
        margin-right: auto;
        height: 40px;

        a {
          display: flex;
          flex-direction: row;
          align-items: center;

          img {
            display: flex;
            flex-direction: row;
            align-items: center;
            height: 40px;
          }
        }
      }

      .profile {
        .profile_icon {
          width: 40px;
          height: 40px;
          overflow: hidden;
          border-radius: 50%;
        }

        .profile_setting {
          display: none;
          background-color: #fff;
          width: 240px;
          padding: 10px 30px;
          border: 1px solid #ccc;
          position: absolute;
          top: 56px;
          right: 0;
          z-index: 2;
          border-radius: 0 0 5px 5px;

          .profile_setting_item {
            &:not(:last-child) {
              padding-bottom: 5px;
            }
          }
        }
      }
    }
  }
}
</style>
