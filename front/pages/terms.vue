<template lang="pug">
.terms_container
  TermsContent
</template>

<script lang="ts">
import { defineComponent } from "@nuxtjs/composition-api"
import TermsContent from "@/components/TermsContent.vue"
export default defineComponent({
  components: {
    TermsContent
  },
  layout: (context) => context.$device.isMobile ? "" : "unauthorized_default",
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .terms_container {
    max-width: 50rem;
    min-width: 50rem;
    margin: 20px auto;
    padding: 20px 30px;
    background-color: #ffffff;
    border-radius: 5px;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    min-height: calc(100vh - 200px);
  }
}

@media all and (max-width: 480px) {
  .terms_container {
    padding: 20px 30px;
    background-color: #ffffff;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
  }
}
</style>
