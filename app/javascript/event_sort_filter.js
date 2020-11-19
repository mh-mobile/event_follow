import Vue from 'vue'
import EventSortFilter from './event_sort_filter.vue'
document.addEventListener('DOMContentLoaded', () => {
  const eventSortFilterElm = document.getElementById('js-event-sort-filter')
  if (eventSortFilterElm) {
    new Vue({
      render: h => h(EventSortFilter)
    }).$mount('#js-event-sort-filter')
  }
})
