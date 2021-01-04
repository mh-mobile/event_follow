<template lang="pug">
.event_held
  .event_date
    | {{ eventDate }}
  .event_start
    | 開催
</template>
<script lang="ts">
import { defineComponent, computed } from "@nuxtjs/composition-api"

export default defineComponent({
  props: {
    startedAt: String
  },
  setup(props) {
    const eventDate = computed(() => {
      if (!props.startedAt || props.startedAt === "") return ""

      const eventDate = new Date(props.startedAt)
      const month = eventDate.getMonth() + 1
      const day = eventDate.getDate()
      return `${month}/${day}`
    })
    return {
      eventDate: eventDate
    }
  }
})
</script>
<style lang="scss" scoped>
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
</style>
