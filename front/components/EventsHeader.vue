<template lang="pug">
.event_list_header
  .event_header_top
    .event_header_info
      | 友達からのイベント情報
    #js-event-sort-filter
      EventSortFilter(:eventSortType="eventSortType" :timeFilterType="timeFilterType" :friendsFilterType="friendsFilterType")
  .event_header_bottom
    Pagination(:totalPages="totalPages" :currentPage="currentPage" :pageWindow="pageWindow")
</template>

<script lang="ts">
import EventSortFilter from "@/components/EventSortFilter.vue"
import Pagination from "@/components/Pagination.vue"
import { defineComponent } from "@nuxtjs/composition-api"

export default defineComponent({
  components: {
    EventSortFilter,
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
    },
    eventSortType: {
      type: String,
      default: ""
    },
    timeFilterType: {
      type: String,
      default: ""
    },
    friendsFilterType: {
      type: String,
      default: ""
    }
  }
})
</script>

<style lang="scss" scoped>
.event_list_header {
  display: flex;
  flex-direction: column;
  margin-bottom: 10px;
  .event_header_top {
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    align-items: center;

    .event_header_info {
      margin-right: auto;
      font-size: 2em;
      font-weight: bold;
    }

    .event_header_sort_filter {
      font-size: 1.5em;
      font-weight: bold;
      position: relative;
      padding-right: 24px;
      cursor: pointer;

      &::after {
        content: "";
        position: absolute;
        width: 12px;
        height: 12px;
        border: 2px solid;
        top: calc(50% - 4px);
        right: 0;
        border-color: transparent transparent #565656 #565656;
        transform: rotate(-45deg) translateY(-50%);
      }
    }
  }
  .event_header_bottom {
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    margin-bottom: 10px;

    .pagination {
      margin-top: 20px;
    }
  }
}
</style>
