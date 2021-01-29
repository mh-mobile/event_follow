<template lang="pug">
  div
    SettingsAccountDeletion
</template>

<script lang="ts">
import SettingsAccountDeletion from "@/components/SettingsAccountDeletion.vue"
import { defineComponent } from "@nuxtjs/composition-api"
import "firebase/auth"

export default defineComponent({
  components: {
    SettingsAccountDeletion
  }
})
</script>
