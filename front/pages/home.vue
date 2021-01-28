<template lang="pug">
div
  .home_container
    HomeConcept
    HomeTwitterLogin
    HomeHowItWorks
</template>

<script lang="ts">
import HomeConcept from "@/components/HomeConcept.vue"
import HomeTwitterLogin from "@/components/HomeTwitterLogin.vue"
import HomeHowItWorks from "@/components/HomeHowItWorks.vue"
import { defineComponent } from "@nuxtjs/composition-api"
export default defineComponent({
  layout: "unauthorized_default",
  components: {
    HomeConcept,
    HomeTwitterLogin,
    HomeHowItWorks
  }
})
</script>

<style lang="scss" scoped>
.home_container {
  max-width: 50rem;
  margin: 0 auto;
  padding-top: 20px;
  min-height: calc(100vh - 160px);
}
</style>
