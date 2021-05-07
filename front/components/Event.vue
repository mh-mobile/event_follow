<template lang="pug">
li.event_item(ref="root")
  .event_detail
    .event_detail_left
      EventHeld(:startedAt="startedAt" :endedAt="endedAt")
      .event_logo
        img(:src="eventLogoImage")
      .tweet_button
    .event_detail_content
      .event_content_top
        .event_content_title
          a(:href="eventInfo.event.url" target="_blank")
            | {{ eventInfo.event.title }}

      .event_content_bottom
        .event_content_thumbnail
          img(:src="eventInfo.event.banner")
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
      }

      .event_detail_content {
        width: calc(100% - 100px);
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-left: 26px;
        box-sizing: border-box;
        margin-top: -2px;

        .event_content_top {
          display: flex;
          flex-direction: row;

          .event_content_title {
            width: 100%;
            font-size: 1.3em;
            font-family: YakuHanJP, "Hiragino Sans", "Hiragino Kaku Gothic ProN",
              "Noto Sans JP", Meiryo, sans-serif;
            overflow-wrap: break-word;
          }

        }

        .event_content_bottom {

          .event_content_description {
            width: 100%;
            margin-top: 10px;
            overflow-wrap: break-word;
          }

          .event_content_thumbnail {
            width: 20%;
            float: right;
            margin-top: 10px;
            margin-left: 5px;
            margin-bottom: 5px;

            img {
              width: 100%;
              height: 100%;
              object-fit: contain;
            }
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
    padding: 1rem;
    border: 1px solid #ccc;
    border-radius: 7px;
    margin-bottom: 20px;
    background-color: #ffffff;

    .event_detail {
      width: 100%;
      display: flex;
      flex-direction: row;

      .event_detail_left {
        width: 54px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;

        .event_logo {
          width: 54px;
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
      }

      .event_detail_content {
        width: calc(100% - 54px);
        height: 100%;
        display: flex;
        flex-direction: column;
        padding-left: 16px;
        box-sizing: border-box;
        margin-top: -2px;

        .event_content_top {
          display: flex;
          flex-direction: row;

          .event_content_title {
            width: 100%;
            font-size: 1em;
            font-family: YakuHanJP, "Hiragino Sans", "Hiragino Kaku Gothic ProN",
              "Noto Sans JP", Meiryo, sans-serif;
            overflow-wrap: break-word;
          }
        }

        .event_content_bottom {

          .event_content_description {
            width: 100%;
            margin-top: 10px;
            font-size: 0.8em;
            overflow-wrap: break-word;
          }

          .event_content_thumbnail {
            width: 20%;
            float: right;
            margin-top: 10px;
            margin-left: 5px;
            margin-bottom: 5px;

            img {
              width: 100%;
              height: 100%;
              object-fit: contain;
            }
          }
        }
      }
    }
  }
}
</style>
