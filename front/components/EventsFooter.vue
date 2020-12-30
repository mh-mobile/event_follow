<template lang="pug">
.event_list_footer
  Pagination(:totalPages="totalPages" :currentPage="currentPage" :pageWindow="pageWindow")
</template>

<script lang="ts">
import Pagination from '@/components/Pagination.vue'
import { defineComponent } from '@nuxtjs/composition-api'

export default defineComponent({
  props: {
    totalPages: Number,
    currentPage: Number,
    pageWindow: Number
  },
  components: {
    Pagination
  }
})
</script>

<style lang="scss" scoped>
.event_list_footer {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;

  .pagination {
    margin-top: 50px;
    margin-bottom: 20px;
  }
}
</style>
