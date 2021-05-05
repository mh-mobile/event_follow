<template lang="pug">
.event_held
  .event_date
    .event_month
      | {{ eventDate.month }}
    span
      | /
    .event_day
      | {{ eventDate.day }}
  .event_start(:class="eventStatusInfo.eventStartStatusStyle")
    | {{ eventStatusInfo.eventStartStatusLabel }}
</template>
<script lang="ts">
import { defineComponent, computed } from "@nuxtjs/composition-api"

export default defineComponent({
  props: {
    startedAt: {
      type: String,
      default: ""
    },
    endedAt: {
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

    const eventStatusInfo = computed(() => {
      if (!props.startedAt || props.startedAt === "") return ""
      if (!props.endedAt || props.endedAt === "") return ""

      const eventStartDate = new Date(props.startedAt)
      const eventEndDate = new Date(props.startedAt)

      const now = new Date()
      let eventStartStatusStyle
      let eventStartStatusLabel
      if (now >= eventStartDate && now <= eventEndDate) {
        eventStartStatusStyle = "event_status_progress"
        eventStartStatusLabel = "開催中"
      } else if (
        now < eventStartDate &&
        eventStartDate.getFullYear() === now.getFullYear() &&
        eventStartDate.getMonth() === now.getMonth() &&
        eventStartDate.getDate() === now.getDate()
      ) {
        eventStartStatusStyle = "event_status_today"
        eventStartStatusLabel = "本日開催"
      } else if (now < eventStartDate) {
        eventStartStatusStyle = "event_status_preparation"
        eventStartStatusLabel = "開催前"
      } else {
        eventStartStatusStyle = "event_status_finished"
        eventStartStatusLabel = "開催終了"
      }

      return {
        eventStartStatusStyle,
        eventStartStatusLabel
      }
    })

    return {
      eventDate,
      eventStatusInfo
    }
  }
})
</script>
<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .event_held {
    width: 100px;
    height: 100px;
    background-color: #efe9e5;
    border-radius: 5px;
    display: flex;
    flex-direction: column;
    justify-items: center;
    overflow: hidden;

    .event_date {
      font-size: 2em;
      height: 70%;
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
      font-size: 1em;
      font-weight: bold;
      height: 30%;
      text-align: center;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #ffffff;
    }

    .event_status_today {
      background-color: #f47721;
    }

    .event_status_progress {
      background-color: #fd5c63;
    }

    .event_status_preparation {
      background-color: #00aeff;
    }

    .event_status_finished {
      background-color: #4a4a4a;
    }
  }
}

@media all and (max-width: 480px) {
  .event_held {
    width: 70px;
    height: 70px;
    background-color: #efe9e5;
    border-radius: 5px;
    display: flex;
    flex-direction: column;
    justify-items: center;
    overflow: hidden;

    .event_date {
      font-size: 1.5em;
      height: 70%;
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
      font-weight: bold;
      height: 30%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #ffffff;
    }

    .event_status_today {
      background-color: #f47721;
    }

    .event_status_progress {
      background-color: #fd5c63;
    }

    .event_status_preparation {
      background-color: #00aeff;
    }

    .event_status_finished {
      background-color: #4a4a4a;
    }
  }
}
</style>
