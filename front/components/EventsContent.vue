<template lang="pug">
  div
    ul(v-show="!isEventEmpty")
      Event(:eventInfo="event" v-for="event in events" :key="event.event.id")
    .no-event(v-show="isEventEmpty")
      | イベントが見つかりません。
</template>

<script lang="ts">
import Event from "@/components/Event.vue"
import { defineComponent, computed } from "@nuxtjs/composition-api"
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
  },
  setup(props) {
    const isEventEmpty = computed(() => {
      return props.events.length === 0
    })
    return {
      isEventEmpty
    }
  }
})
</script>

<style lang="scss" scoped>
.no-event {
  width: 100%;
  height: 15em;
  background-color: #f3f4f7;
  border-radius: 5px;
  border: 1px solid #d7d7d8;
  margin-bottom: 10px;
  color: #6a737b;
  font-weight: bold;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
