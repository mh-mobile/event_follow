<template lang="pug">
li.event_item
  .event_detail
    .event_detail_left
      EventHeld
      .event_logo
        img(src="@/assets/connpass_logo.png")
    .event_detail_content
      .event_content_top
        .event_content_title
          a(href="/" target="_blank")
            | イベントタイトル
        .event_content_thumbnail
          img(src="@/assets/logo_transparent.png")

      .event_content_bottom
        .event_content_description
          | イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要イベント概要
  #js-friends-list
    FriendsList(:eventId="eventId" :userIds="userIds" :friendsNumber="friendsNumber")
</template>

<script lang="ts">
import EventHeld from '@/components/EventHeld.vue'
import FriendsList from '@/components/FriendsList.vue'
import { defineComponent } from '@vue/composition-api'

export default defineComponent({
  components: {
    EventHeld,
    FriendsList
  },
  setup () {
    return {
      eventId: '1',
      userIds: '1,2',
      friendsNumber: '5'
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
        margin-top: 10px;
      }

      .event_held {
        width: 100px;
        height: 100px;
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