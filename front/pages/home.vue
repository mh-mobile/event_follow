<template lang="pug">
div
  .home_container
    HomeConcept
    HomeTwitterLogin
    HomeHowItWorks(v-if="$device.isDesktop")
</template>

<script lang="ts">
import HomeConcept from "@/components/HomeConcept.vue"
import HomeTwitterLogin from "@/components/HomeTwitterLogin.vue"
import HomeHowItWorks from "@/components/HomeHowItWorks.vue"
import { defineComponent } from "@nuxtjs/composition-api"
export default defineComponent({
  components: {
    HomeConcept,
    HomeTwitterLogin,
    HomeHowItWorks
  },
  layout: "unauthorized_default"
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .home_container {
    max-width: 50rem;
    margin: 0 auto;
    padding-top: 20px;
    min-height: calc(100vh - 160px);
  }
}

@media all and (max-width: 480px) {
  .home_container {
    margin: 0 auto;
    padding-top: 20px;
    min-height: calc(100vh - 160px);
  }
}
</style>
