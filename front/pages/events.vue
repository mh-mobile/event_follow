<template lang="pug">
div
  .header
    .container
      .logo
        a(href="/events")
          img(src="@/assets/logo_transparent.png")
      .profile
        #js-profile.profile_icon
          //- = image_tag current_user.profile_image
        //- = render partial: "profile_setting"
  .event_container
    EventsHeader
    EventsContent
    EventsFooter

</template>

<script lang="ts">
import EventsHeader from '@/components/EventsHeader.vue'
import EventsContent from '@/components/EventsContent.vue'
import EventsFooter from '@/components/EventsFooter.vue'
import { defineComponent } from '@vue/composition-api'
export default defineComponent({
  components: {
    EventsHeader,
    EventsContent,
    EventsFooter
  }
})
</script>

<style lang="scss" scoped>

.header {
  padding: 5px;
  background-color: #efe9e5;

  .container {
    max-width: 50rem;
    margin: 0 auto;
    padding: 5px;
    height: 70px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: flex-end;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    position: relative;

    .logo {
      margin-right: auto;
      width: 100px;
      height: auto;
    }
  }
}

.event_container {
  max-width: 50rem;
  min-width: 50rem;
  margin: 0 auto;
  margin-top: 20px;
  margin-bottom: 20px;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 5px;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

</style>
