import { computed, reactive, ref } from "@nuxtjs/composition-api"
import sanitizeHtml from "sanitize-html"

const EVENT_DESCRIPTION_MAX_LENGTH = 250
const CONNPASS_EVENT_SITE_ID = 1
const DOORKEEPER_EVENT_SITE_ID = 2
const TECHPLAY_EVENT_SITE_ID = 3

export const useEvent = (props: any) => {
  const state = reactive({
    eventId: 0,
    userIds: "",
    friendsNumber: 0,
    startedAt: "",
    endedAt: "",
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
    const twitterIframe = root.value?.querySelector(".tweet_button iframe")
    twitterIframe?.remove()

    const twitterButton = root.value?.querySelector(".tweet_button")
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
    state.endedAt = eventInfo.event.ended_at

    updateTwitterButton(eventInfo)
  }

  return {
    state,
    root,
    sanitizedDescription,
    eventLogoImage,
    updateState
  }
}
