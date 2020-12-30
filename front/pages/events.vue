<template lang="pug">
div
  .header
    .container
      .logo
        a(href="/events")
          img(src="@/assets/logo_transparent.png")
      client-only
        .profile
          #js-profile.profile_icon(v-if="currentUser")
            img.profile_image(:src="currentUser.photoURL")
          ul.profile_setting#js-profile-setting(v-show="currentUser")
            li.profile_setting_item(v-if="currentUser")
              | {{ currentUser.displayName }}
            li.profile_setting_item
              a(href="#" @click="logout")
                | ログアウト
  .event_container
    EventsHeader
    EventsContent(:events="events")
    EventsFooter

</template>

<script lang="ts">
import EventsHeader from '@/components/EventsHeader.vue'
import EventsContent from '@/components/EventsContent.vue'
import EventsFooter from '@/components/EventsFooter.vue'
import { defineComponent, onUnmounted, onMounted, useContext, useAsync, useFetch, ref } from '@nuxtjs/composition-api'
import { useCurrentUser } from '@/compositions/user'
import { useProfileSettings } from '@/compositions/profile_settings'

import firebase from 'firebase/app'
import 'firebase/auth'
const Cookie = process.client ? require('js-cookie') : undefined

export default defineComponent({
  components: {
    EventsHeader,
    EventsContent,
    EventsFooter
  },
  setup (props, { root }) {
    const events = ref([])
    if (process.server) {
      return {
        currentUser: null,
        logout: null,
        events: events
      }
    }

    const fetch = useFetch(async () => {
      const currentUser = firebase.auth().currentUser
      if (currentUser == null) return
      const idToken = await currentUser.getIdToken()
      root.$axios.get(`/api/events`, {
        headers: {
          "Authorization": `Bearer ${idToken}`
        }
      }).then((response) => {
        events.value = response.data.data
      }).catch((error) => {
        console.log(`error: ${error}`)
      })  
    })

    const { currentUser } = useCurrentUser()
    const { store, params, query } = useContext()
    const { showProfileSettings, hideProfileSettings } = useProfileSettings()

    const logout = () => {
      firebase.auth().signOut().then(() => {
        store.commit("setAuth", null)
        Cookie.remove("auth")
        window.location.href = "/home"
      })
    }

    onMounted(() => {
      root.$nextTick(() => {
        showProfileSettings()
      })
    })

    onUnmounted(() => {
      hideProfileSettings()
    })

    return {
      currentUser,
      logout,
      events
    }
  }
})
</script>

<style lang="scss" scoped>

.header {
  padding: 5px;
  background-color: #efe9e5;

  .container {
    max-width: 50rem;
    margin: 0 auto;
    padding: 5px;
    height: 70px;
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
      width: 100px;
      height: auto;
    }

    .profile {
      .profile_icon {
        width: 48px;
        height: 48px;
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
        top: 75px;
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

.event_container {
  max-width: 50rem;
  min-width: 50rem;
  margin: 0 auto;
  margin-top: 20px;
  margin-bottom: 20px;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 5px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

</style>
