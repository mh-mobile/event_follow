import Vue from 'vue'
import EventSortFilter from './event_sort_filter.vue'
document.addEventListener('DOMContentLoaded', () => {
  const eventSortFilterElm = document.getElementById('js-event-sort-filter')
  const eventSortType = eventSortFilterElm.getAttribute('event-sort-type')
  const timeFilterType = eventSortFilterElm.getAttribute('time-filter-type')
  const friendsFilterType = eventSortFilterElm.getAttribute('friends-filter-type')
  if (eventSortFilterElm) {
    new Vue({
      render: h => h(EventSortFilter, { props: {
        eventSortType: eventSortType,
        timeFilterType: timeFilterType,
        friendsFilterType: friendsFilterType,
      }})
    }).$mount('#js-event-sort-filter')
  }
})
