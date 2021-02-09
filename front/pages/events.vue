<template lang="pug">
div
  .event_container(v-show="!isInitialLoading")
    EventsHeader(:totalPages="totalPages" :currentPage="currentPage" :pageWindow="pageWindow"
                 :eventSortType="eventSortType" :timeFilterType="timeFilterType" :friendsFilterType="friendsFilterType")
    EventsContent(:events="events")
    EventsFooter(:totalPages="totalPages" :currentPage="currentPage" :pageWindow="pageWindow")
  .event_container(v-show="isInitialLoading")
    Loading
  TopScrollButton
</template>

<script lang="ts">
import EventsHeader from "@/components/EventsHeader.vue"
import EventsContent from "@/components/EventsContent.vue"
import EventsFooter from "@/components/EventsFooter.vue"
import Loading from "@/components/Loading.vue"
import TopScrollButton from "@/components/TopScrollButton.vue"

import {
  defineComponent,
  onUnmounted,
  onMounted,
  useContext,
  useFetch,
  toRefs,
  reactive,
  watch
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
  components: {
    EventsHeader,
    EventsContent,
    EventsFooter,
    Loading,
    TopScrollButton
  },
  layout: "authorized_default",
  setup(props, { root }) {
    const state = reactive({
      events: [],
      totalPages: 0,
      currentPage: 1,
      pageWindow: 2,
      eventSortType: "",
      timeFilterType: "",
      friendsFilterType: "",
      isInitialLoading: true
    })
    if (process.server) {
      return {
        logout: null,
        ...toRefs(state)
      }
    }

    const { store, query } = useContext()

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

    const requestEventAPI = async (
      idToken: string,
      params: Record<string, any>
    ) => {
      root.$nuxt.$loading.start()
      root.$axios
        .get("/api/events", {
          headers: {
            Authorization: `Bearer ${idToken}`
          },
          params: params
        })
        .then((response) => {
          state.events = response.data.data
          state.totalPages = response.data.meta.total_pages
          state.currentPage = response.data.meta.current_page
          state.eventSortType = response.data.meta.event_sort_type
          state.timeFilterType = response.data.meta.time_filter_type
          state.friendsFilterType = response.data.meta.friends_filter_type
          state.isInitialLoading = false
          root.$nuxt.$loading.finish()
        })
        .catch((error) => {
          state.isInitialLoading = false
          root.$nuxt.$loading.finish()
          root.$sentry.captureException(error)
          if (error.response.status === 401) {
            logout()
          }
        })
    }

    useFetch(async () => {
      const currentUser = firebase.auth().currentUser
      if (currentUser == null) return
      const idToken = await currentUser.getIdToken()

      state.currentPage = Number(query.value.page)
        ? Number(query.value.page)
        : 1
      const params = {
        page: state.currentPage
      }

      requestEventAPI(idToken, params)
    })

    const { showProfileSettings, hideProfileSettings } = useProfileSettings()

    watch(
      () => root.$route,
      async (to) => {
        if (to.path === "/events") {
          const currentUser = firebase.auth().currentUser
          if (currentUser == null) return
          const idToken = await currentUser.getIdToken()
          requestEventAPI(idToken, to.query)
        }
      }
    )

    onMounted(() => {
      root.$nextTick(() => {
        showProfileSettings()
      })
    })

    onUnmounted(() => {
      hideProfileSettings()
    })

    return {
      logout,
      ...toRefs(state)
    }
  }
})
</script>

<style lang="scss" scoped>
.event_container {
  max-width: 50rem;
  min-width: 50rem;
  margin: 0 auto;
  margin-top: 20px;
  margin-bottom: 20px;
  padding: 20px 30px;
  background-color: #ffffff;
  border-radius: 5px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}
</style>
