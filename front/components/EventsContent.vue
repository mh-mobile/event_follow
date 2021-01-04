<template lang="pug">
 ul
  li(v-for="event in events")
    Event(:eventInfo="event")
</template>

<script lang="ts">
import Event from "@/components/Event.vue"
import { defineComponent } from "@nuxtjs/composition-api"
import "firebase/auth"

export default defineComponent({
  components: {
    Event
  },
  props: {
    events: {
      type: Array,
      default: () => []
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
