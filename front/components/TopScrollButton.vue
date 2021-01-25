<template lang="pug">
.top-scroll-button(v-show="scrollButtonActive" @click="scrollToTop")
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  reactive,
  toRefs
} from "@nuxtjs/composition-api"

export default defineComponent({
  setup() {
    const state = reactive({
      scrollButtonActive: false
    })

    const scrollToTop = () => {
      window.scrollTo({
        top: 0,
        behavior: "smooth"
      })
    }

    const scrollWindow = () => {
      const top = 100
      const scrollY = window.scrollY
      if (top <= scrollY) {
        state.scrollButtonActive = true
      } else {
        state.scrollButtonActive = false
      }
    }

    onMounted(() => {
      window.addEventListener("scroll", scrollWindow)
    })

    return {
      ...toRefs(state),
      scrollToTop
    }
  }
})
</script>

<style lang="scss" scoped>
.top-scroll-button {
  width: 60px;
  height: 60px;
  background-color: #1b80d8;
  position: fixed;
  right: 20px;
  bottom: 20px;
  border-radius: 50%;
  cursor: pointer;
  position: fixed;

  &::after {
    content: "";
    position: absolute;
    display: inline-block;
    width: 20px;
    height: 20px;
    top: calc(50% + 5px);
    left: 50%;
    border-top: 4px solid #ffffff;
    border-left: 4px solid #ffffff;
    box-sizing: border-box;
    transform: translateX(-50%) translateY(-50%) rotate(45deg);
  }

  &:hover {
    opacity: 0.8;
  }
}
</style>
