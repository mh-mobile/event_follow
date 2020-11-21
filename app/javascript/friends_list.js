import Vue from 'vue'
import FrindsList from './friends_list.vue'
document.addEventListener('DOMContentLoaded', () => {
  const friendsListElms = document.querySelectorAll(`[id^="js-friends-list-"]`)
  if (friendsListElms && friendsListElms.length > 0) {
      for (let friendsListElm of friendsListElms) {
        const eventId = friendsListElm.getAttribute('event-id')
        new Vue({
          render: h => h(FrindsList, { 
            props: {
              event_id: eventId
            }
          })
        }).$mount(`#${friendsListElm.id}`)
      }
    }
})
