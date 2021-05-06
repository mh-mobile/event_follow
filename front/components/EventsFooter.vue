<template lang="pug">
.event_list_footer
  Pagination(:totalPages="totalPages" :currentPage="currentPage" :pageWindow="pageWindow" v-show="totalPages > 0")
</template>

<script lang="ts">
import Pagination from "@/components/Pagination.vue"
import { defineComponent } from "@nuxtjs/composition-api"

export default defineComponent({
  components: {
    Pagination
  },
  props: {
    totalPages: {
      type: Number,
      default: 0
    },
    currentPage: {
      type: Number,
      default: 1
    },
    pageWindow: {
      type: Number,
      default: 2
    }
  }
})
</script>

<style lang="scss" scoped>
.event_list_footer {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;

  @media all and (max-width: 480px) {
    margin-bottom: 50px;
  }

  .pagination {
    margin-top: 50px;
    margin-bottom: 20px;
  }
}
</style>
