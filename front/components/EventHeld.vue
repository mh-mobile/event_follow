<template lang="pug">
.event_held
  .event_date
    .event_month
      | {{ eventDate.month }}
    span
      | /
    .event_day
      | {{ eventDate.day }}
  .event_start
    | 開催
</template>
<script lang="ts">
import { defineComponent, computed } from "@nuxtjs/composition-api"

export default defineComponent({
  props: {
    startedAt: {
      type: String,
      default: ""
    }
  },
  setup(props) {
    const eventDate = computed(() => {
      if (!props.startedAt || props.startedAt === "") return ""

      const eventDate = new Date(props.startedAt)
      const month = eventDate.getMonth() + 1
      const day = eventDate.getDate()
      return {
        month,
        day
      }
    })
    return {
      eventDate: eventDate
    }
  }
})
</script>
<style lang="scss" scoped>
@media all and (min-width: 480px) {
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
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      padding-top: 5px;

      span {
        margin: 0 2px;
      }
    }

    .event_start {
      font-size: 1.2em;
      height: 50%;
      text-align: center;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}

@media all and (max-width: 480px) {
  .event_held {
    width: 70px;
    height: 70px;
    border: 1px solid #cccccc;
    background-color: #f3f4f7;
    border-radius: 5px;
    display: flex;
    flex-direction: column;
    justify-items: center;

    .event_date {
      font-size: 1.5em;
      height: 50%;
      text-align: center;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      padding-top: 5px;

      span {
        margin: 0 2px;
      }
    }

    .event_start {
      font-size: 0.8em;
      height: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}
</style>
