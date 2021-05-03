<template lang="pug">
.event_pagination
  ul
    li(v-for="(page, index) in pages" :key="index" @click="showPage(page.value)", :class="page.class")
      | {{ page.label }}
</template>

<script lang="ts">
import { defineComponent, computed } from "@nuxtjs/composition-api"

export default defineComponent({
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
  },
  setup(props, { root }) {
    if (process.server) {
      return {
        pages: [],
        showPage: null
      }
    }

    const pages = computed(() => {
      const currentPage = props.currentPage ? props.currentPage : 1
      const totalPages = props.totalPages ? props.totalPages : 0
      const pageWindow = props.pageWindow ? props.pageWindow : 2
      let _pages = []
      _pages.push({
        label: "最初",
        value: "1",
        class: currentPage === 1 ? "click_disable" : ""
      })

      _pages.push({
        label: "前へ",
        value: currentPage - 1,
        class: currentPage === 1 ? "click_disable" : ""
      })

      if (currentPage > 1 + pageWindow) {
        _pages.push({
          label: "...",
          value: "",
          class: "intermediate_page click_disable"
        })
      }

      for (let page = currentPage - pageWindow; page < currentPage; page++) {
        if (page < 1) continue

        _pages.push({
          label: page,
          value: page,
          class: "page_item"
        })
      }

      _pages.push({
        label: currentPage,
        value: currentPage,
        class: "current_page click_disable page_item"
      })

      for (
        let page = currentPage + 1;
        page <= currentPage + pageWindow;
        page++
      ) {
        if (page > totalPages) continue

        _pages.push({
          label: page,
          value: page,
          class: "page_item"
        })
      }

      if (currentPage < totalPages - pageWindow) {
        _pages.push({
          label: "...",
          value: "",
          class: "intermediate_page click_disable"
        })
      }

      _pages.push({
        label: "次へ",
        value: currentPage + 1,
        class: currentPage === totalPages ? "click_disable" : ""
      })

      _pages.push({
        label: "最後",
        value: totalPages,
        class: currentPage === totalPages ? "click_disable" : ""
      })

      return _pages
    })

    const showPage = (page: number) => {
      root.$router.replace(`/events?page=${page}`)
    }

    return {
      pages: pages,
      showPage: showPage
    }
  }
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .event_pagination {
    width: 100%;
  }

  .event_pagination ul {
    display: flex;
    flex-direction: row;
    justify-content: center;

    li {
      padding: 10px 15px;
      border-top: 1px solid #ccc;
      border-bottom: 1px solid #ccc;
      cursor: pointer;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      &:not(:last-child) {
        border-right: 1px solid #ccc;
      }

      &:first-child {
        border-left: 1px solid #ccc;
        border-top-left-radius: 5px;
        border-bottom-left-radius: 5px;
      }

      &:last-child {
        border-right: 1px solid #ccc;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
      }
    }

    .page_item {
      min-width: 50px;
    }

    .current_page {
      background-color: #4d4f53 !important;
      color: #fff !important;
      border-top: 1px solid #4d4f53 !important;
      border-bottom: 1px solid #4d4f53 !important;
    }

    .intermediate_page {
      border-top: 1px solid #ccc !important;
      border-bottom: 1px solid #ccc !important;
      color: #000 !important;
      background: #fff !important;
      min-width: 50px;
    }

    .click_disable {
      pointer-events: none;
      color: #ccc;
    }
  }
}

@media all and (max-width: 480px) {
  .event_pagination {
    width: 100%;
  }

  .event_pagination ul {
    width: 100%;
    display: flex;
    flex-direction: row;
    justify-content: stretch;
    font-size: 0.8em; 

    li {
      flex-grow: 1;
      height: 40px;
      border-top: 1px solid #ccc;
      border-bottom: 1px solid #ccc;
      background-color: #ffffff;
      cursor: pointer;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      white-space: nowrap;
      
      &:not(:last-child) {
        border-right: 1px solid #ccc;
      }

      &:first-child {
        border-left: 1px solid #ccc;
        border-top-left-radius: 5px;
        border-bottom-left-radius: 5px;
      }

      &:last-child {
        border-right: 1px solid #ccc;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
      }
    }

    .page_item {
      min-width: 50px;
    }

    .current_page {
      background-color: #4d4f53 !important;
      color: #fff !important;
      border-bottom: 1px solid #ccc;
      background-color: #ffffff;
    }

    .intermediate_page {
      border-top: 1px solid #ccc !important;
      border-bottom: 1px solid #ccc !important;
      color: #000 !important;
      background: #fff !important;
      min-width: 50px;
    }

    .click_disable {
      pointer-events: none;
      color: #ccc;
    }
  }
}
</style>
