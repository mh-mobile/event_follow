<template lang="pug">
div
  .settings_container
    SettingsHeader
    SettingsContent
</template>

<script lang="ts">
import {
  defineComponent,
  onUnmounted,
  onMounted
} from "@nuxtjs/composition-api"
import { useProfileSettings } from "@/compositions/profile_settings"

export default defineComponent({
  layout: "authorized_default",
  setup(props, { root }) {
    const { showProfileSettings, hideProfileSettings } = useProfileSettings()

    onMounted(() => {
      root.$nextTick(() => {
        showProfileSettings()
      })
    })

    onUnmounted(() => {
      hideProfileSettings()
    })
  }
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .settings_container {
    max-width: 50rem;
    min-width: 50rem;
    margin: 0 auto;
    margin-top: 20px;
    margin-bottom: 20px;
    padding: 20px 30px;
    background-color: #ffffff;
    border-radius: 5px;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
  }
}

@media all and (max-width: 480px) {
  .settings_container {
    margin: 0 auto;
    margin-top: 20px;
    margin-bottom: 20px;
    padding: 20px 30px;
    background-color: #ffffff;
    border-radius: 5px;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
  }
}
</style>
