import Vue from 'vue'
import FrindsList from './friends_list.vue'
document.addEventListener('DOMContentLoaded', () => {
  const friendsListElms = document.querySelectorAll(`[id^="js-friends-list-"]`)
  if (friendsListElms && friendsListElms.length > 0) {
      for (let friendsListElm of friendsListElms) {
        const eventId = friendsListElm.getAttribute('event-id')
        const userIds = friendsListElm.getAttribute('user-ids')
        const friendsNumber = friendsListElm.getAttribute('friends-number')
        new Vue({
          render: h => h(FrindsList, { 
            props: {
              eventId: eventId,
              userIds: userIds,
              friendsNumber: friendsNumber,
            }
          })
        }).$mount(`#${friendsListElm.id}`)
      }
    }
})
