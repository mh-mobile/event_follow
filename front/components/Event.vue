<template lang="pug">
li.event_item(ref="root")
  .event_detail
    .event_detail_left
      EventHeld(:startedAt="startedAt")
      .event_logo
        img(:src="eventLogoImage")
      .tweet_button
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
  toRefs,
  watch
} from "@nuxtjs/composition-api"

import { useEvent } from "@/compositions/event_helper"

export default defineComponent({
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
    const {
      state,
      root,
      sanitizedDescription,
      eventLogoImage,
      updateState
    } = useEvent(props)

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
  },
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
  }
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .event_item {
    display: flex;
    flex-direction: column;
    margin-bottom: 20px;
    &:not(:last-child) {
      border-bottom: 1px solid #ccc;
    }

    .event_detail {
      width: 100%;
      display: flex;
      flex-direction: row;

      .event_detail_left {
        width: 100px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;

        .event_logo {
          width: 100px;
          height: auto;
          margin-top: 12px;
        }

        .tweet_button {
          width: 100px;
          margin-top: 5px;
          display: flex;
          justify-content: center;
        }

        .event_held {
          width: 100px;
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
        width: calc(100% - 100px);
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-left: 26px;
        box-sizing: border-box;

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

          .event_content_description {
            width: 100%;
            margin-top: 10px;
          }
        }
      }
    }
  }
}

@media all and (max-width: 480px) {
  .event_item {
    display: flex;
    flex-direction: column;
    margin-bottom: 20px;
    &:not(:last-child) {
      border-bottom: 1px solid #ccc;
    }

    .event_detail {
      width: 100%;
      display: flex;
      flex-direction: row;

      .event_detail_left {
        width: 70px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;

        .event_logo {
          width: 70px;
          height: auto;
          margin-top: 12px;
        }

        .tweet_button {
          width: 100px;
          margin-top: 5px;
          display: flex;
          justify-content: center;
          display: none;
        }

        .event_held {
          width: 70px;
          border: 1px solid #cccccc;
          background-color: #f3f4f7;
          border-radius: 5px;
          display: flex;
          flex-direction: column;
          justify-items: center;

          .event_date {
            height: 50%;
            text-align: center;
          }

          .event_start {
            height: 50%;
            text-align: center;
          }
        }
      }

      .event_detail_content {
        width: calc(100% - 70px);
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-left: 26px;
        box-sizing: border-box;

        .event_content_top {
          display: flex;
          flex-direction: row;
          height: 40%;

          .event_content_title {
            width: 80%;
            font-size: 1em;
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

          .event_content_description {
            width: 100%;
            margin-top: 10px;
            font-size: 0.8em;
          }
        }
      }
    }
  }
}
</style>
