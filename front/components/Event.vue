<template lang="pug">
li.event_item(ref="root")
  .event_detail
    .event_detail_left
      EventHeld(:startedAt="startedAt")
      .event_logo
        img(:src="eventLogoImage")
      .twitter_button
    .event_detail_content
      .event_content_top
        .event_content_title
          a(:href="eventInfo.event.url" target="_blank")
            | {{ eventInfo.event.title }}
        .event_content_thumbnail
          img(:src="eventInfo.event.banner")

      .event_content_bottom
        .event_content_description
          | {{ sanitizedDescription }}
  #js-friends-list
    FriendsList(:eventId="eventId" :userIds="userIds" :friendsNumber="friendsNumber")
</template>

<script lang="ts">
import EventHeld from "@/components/EventHeld.vue"
import FriendsList from "@/components/FriendsList.vue"
import {
  defineComponent,
  onMounted,
  reactive,
  toRefs,
  computed,
  watch,
  ref
} from "@nuxtjs/composition-api"
import sanitizeHtml from "sanitize-html"

const EVENT_DESCRIPTION_MAX_LENGTH = 250
const CONNPASS_EVENT_SITE_ID = 1
const DOORKEEPER_EVENT_SITE_ID = 2
const TECHPLAY_EVENT_SITE_ID = 3

export default defineComponent({
  head: {
    script: [
      {
        hid: "twitter",
        type: "text/javascript",
        src: "//platform.twitter.com/widgets.js",
        async: true,
        defer: true,
        body: true
      }
    ]
  },
  components: {
    EventHeld,
    FriendsList
  },
  props: {
    eventInfo: {
      type: Object,
      default: null
    }
  },
  setup(props) {
    const state = reactive({
      eventId: 0,
      userIds: "",
      friendsNumber: 0,
      startedAt: "",
      connpassLogoImage: require("@/assets/connpass_logo.png"),
      doorKeeperLogoImage: require("@/assets/doorkeeper_logo.png"),
      techplayLogoImage: require("@/assets/logo_transparent.png"),
      noLogoImage: require("@/assets/logo_transparent.png")
    })

    const sanitizedDescription = computed(() => {
      let description = props.eventInfo ? props.eventInfo.event.description : ""
      description = sanitizeHtml(description, {
        allowedTags: []
      })
      if (description.length > EVENT_DESCRIPTION_MAX_LENGTH) {
        description = description.slice(0, EVENT_DESCRIPTION_MAX_LENGTH) + "..."
      }
      return description
    })

    const eventLogoImage = () => {
      const siteId = props.eventInfo ? props.eventInfo.event.site_id : -1
      let logo = state.connpassLogoImage
      switch (siteId) {
        case CONNPASS_EVENT_SITE_ID:
          logo = state.connpassLogoImage
          break
        case DOORKEEPER_EVENT_SITE_ID:
          logo = state.doorKeeperLogoImage
          break
        case TECHPLAY_EVENT_SITE_ID:
          logo = state.techplayLogoImage
          break
        default:
          logo = state.noLogoImage
          break
      }
      return logo
    }

    const root = ref<HTMLElement | null>(null)
    const updateTwitterButton = (eventInfo: Record<string, any>) => {
      const twitterIframe = root.value?.querySelector(".twitter_button iframe")
      twitterIframe?.remove()

      const twitterButton = root.value?.querySelector(".twitter_button")
      const twitterAnchor = document.createElement("a")
      twitterAnchor.classList.add("twitter-share-button")
      twitterAnchor.setAttribute(
        "href",
        "https://twitter.com/share?ref_src=twsrc%5Etfw"
      )
      twitterAnchor.setAttribute("data-url", eventInfo.event.url)
      twitterAnchor.setAttribute("data-text", eventInfo.event.title)
      twitterAnchor.setAttribute("data-size", "large")
      twitterAnchor.setAttribute("data-lang", "ja")
      twitterAnchor.setAttribute("data-show-count", "false")
      twitterAnchor.setAttribute("target", "_blank")
      twitterButton?.appendChild(twitterAnchor)

      window?.twttr?.widgets?.load()
    }

    const updateState = (eventInfo: Record<string, any>) => {
      if (!eventInfo) return
      state.eventId = eventInfo.event.id
      state.userIds = eventInfo.extra.user_ids
      state.friendsNumber = eventInfo.extra.friends_number
      state.startedAt = eventInfo.event.started_at

      updateTwitterButton(eventInfo)
    }

    watch(
      () => props.eventInfo,
      async (newValue) => {
        updateState(newValue)
      }
    )

    onMounted(() => {
      updateState(props.eventInfo)
    })

    return {
      ...toRefs(state),
      sanitizedDescription,
      eventLogoImage: eventLogoImage(),
      root
    }
  }
})
</script>

<style lang="scss" scoped>
.event_item {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
  &:not(:last-child) {
    border-bottom: 1px solid #ccc;
  }

  .event_detail {
    width: 100%;
    height: 300px;
    display: flex;
    flex-direction: row;

    .event_detail_left {
      width: 20%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: flex-start;

      .event_logo {
        width: 100px;
        height: auto;
        margin-top: 12px;
      }

      .twitter_button {
        margin-top: 5px;
      }

      .event_held {
        width: 100px;
        height: 40%;
        border: 1px solid #cccccc;
        background-color: #f3f4f7;
        border-radius: 5px;
        display: flex;
        flex-direction: column;
        justify-items: center;

        .event_date {
          font-size: 2em;
          height: 50%;
          text-align: center;
        }

        .event_start {
          font-size: 1.5em;
          height: 50%;
          text-align: center;
        }
      }
    }

    .event_detail_content {
      width: 80%;
      height: 100%;
      display: flex;
      flex-direction: column;

      .event_content_top {
        display: flex;
        flex-direction: row;
        height: 40%;

        .event_content_title {
          width: 80%;
          font-size: 1.3em;
          padding-right: 5px;
        }

        .event_content_thumbnail {
          width: 20%;

          img {
            width: 100%;
            height: 100%;
            object-fit: contain;
          }
        }
      }

      .event_content_bottom {
        display: flex;
        flex-direction: column;
        height: 60%;
        overflow: scroll;

        .event_content_description {
          width: 100%;
          height: 100%;
          margin-top: 10px;
        }
      }
    }
  }
}
</style>
