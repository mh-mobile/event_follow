<template lang="pug">
  .friends_list
    .friend_number(@click="openModal")
      | {{ friendsNumber }}

    .friend_icon(v-for="(userId, index) in userIdsArray" :key="`placeholder-${index}`" v-show="friends.length == 0")
      .noimage
    .friend_icon(v-for="(friend, index) in displayableFriends" :key="`frineds-${index}`" v-show="friends.length > 0")
      a(:href="friendScreenName(friend)" target="_blank"  v-if="$checkUrl(friendScreenName(friend))")
        img(:src="friend.profile_image" v-if="$checkUrl(friend.profile_image)")

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        Loading(v-show="isLoading")
        ul.tweet_list(v-show="!isLoading")
          li.tweet_item(v-for="tweet in tweets" :key="tweet.id")
            .friend_column
              .profile_icon
                a(:href="friendScreenName(tweet.user)" target="_blank" v-if="$checkUrl(friendScreenName(tweet.user))")
                  img(:src="tweet.user.profile_image" v-if="$checkUrl(tweet.user.profile_image)")
            .tweet_column
              .tweet_user
                .twitter_user_name
                  | {{ tweet.user.name }}
                .twitter_user_screen_name
                  | @{{ tweet.user.screen_name }}
              .tweet_content(v-auto-link)
                | {{ tweet.text }}
              .tweet_datetime
                | {{ dateFormat(tweet.tweeted_at) }}
</template>

<script>
import Modal from "@/components/Modal.vue"
import Loading from "@/components/Loading.vue"
import {
  defineComponent,
  computed,
  reactive,
  toRefs,
  watch
} from "@nuxtjs/composition-api"
import firebase from "firebase/app"
import "firebase/auth"
import { useModalHelper } from "@/compositions/modal_helper"

export default defineComponent({
  components: { Modal, Loading },
  directives: {
    "auto-link": {
      inserted(el) {
        el.innerHTML = el.innerHTML.replace(
          /(https?:\/\/[a-zA-Z0-9\-_.:@!~*'(¥);/?&=+$,%#]+)/g,
          '<a href="$1" target="_blank">$1</a>'
        )
        el.innerHTML = el.innerHTML.replace(
          /([@#])([\w]+)/gi,
          (_, prefix, word) => {
            const text = prefix + word
            const route = prefix === "@" ? word : `hashtag/${word}`
            return `<a href="https://twitter.com/${route}" target="_blank">${text}</a>`
          }
        )
      }
    }
  },
  props: {
    eventId: {
      type: Number,
      default: 0
    },
    userIds: {
      type: String,
      default: ""
    },
    friendsNumber: {
      type: Number,
      default: 0
    }
  },
  setup(props, { root }) {
    if (process.server) {
      return
    }

    const state = reactive({
      modal: false,
      tweets: [],
      friends: []
    })

    const isLoading = computed(() => {
      return state.tweets.length === 0
    })

    const userIdsArray = computed(() => {
      if (props.userIds === "") return []
      return props.userIds.split(",")
    })

    const displayableFriends = computed(() => {
      return state.friends
    })

    const { setScrollEnabled } = useModalHelper()

    const openModal = async () => {
      state.modal = true
      setScrollEnabled(false)

      if (isLoading) {
        const idToken = await firebase.auth().currentUser.getIdToken()
        root.$axios
          .get(`/api/following_tweets?event_id=${props.eventId}`, {
            headers: {
              Authorization: `Bearer ${idToken}`
            }
          })
          .then((response) => {
            state.tweets = response.data
          })
          .catch((error) => {
            root.$sentry.captureException(error)
          })
      }
    }

    const closeModal = () => {
      state.modal = false
      setScrollEnabled(true)
    }

    const dateFormat = (value) => {
      const date = new Date(value)
      const year = String(date.getFullYear())
      const month = String(date.getMonth() + 1).padStart(2, "0")
      const day = String(date.getDate()).padStart(2, "0")
      const hour = String(date.getHours()).padStart(2, "0")
      const minute = String(date.getMinutes()).padStart(2, "0")
      return `${year}/${month}/${day} ${hour}:${minute}`
    }

    const friendScreenName = (value) => {
      return `https://twitter.com/${value.screen_name}`
    }

    const updateFriends = async (userIds) => {
      const idToken = await firebase.auth().currentUser.getIdToken()
      root.$axios
        .get(`/api/friendships.json?user_ids=${userIds}`, {
          headers: {
            Authorization: `Bearer ${idToken}`
          }
        })
        .then((response) => {
          state.friends = response.data
        })
        .catch((error) => {
          root.$sentry.captureException(error)
        })
    }

    watch(
      () => props.friendsNumber,
      (newValue) => {
        state.friendsNumber = newValue
      }
    )

    watch(
      () => props.userIds,
      (newValue, oldValue) => {
        if (newValue !== oldValue && newValue !== "") {
          updateFriends(newValue)
        }
      }
    )

    return {
      ...toRefs(state),
      isLoading,
      userIdsArray,
      displayableFriends,
      openModal,
      closeModal,
      dateFormat,
      friendScreenName
    }
  }
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .event-modal-container {
    max-width: 30em;
    min-width: 30em;
    max-height: 80vh;
    overflow-y: scroll;
    .tweet_list {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      box-sizing: border-box;
      .tweet_item {
        display: flex;
        flex-direction: row;
        box-sizing: border-box;
        &:not(:last-child) {
          border-bottom: 1px solid #ccc;
        }
        .friend_column {
          width: 10%;
          display: flex;
          flex-direction: column;
          box-sizing: border-box;
          margin: 5px;
          .profile_icon {
            overflow: hidden;
            margin-top: 5px;
            img {
              border-radius: 50%;
              width: 50px;
              height: auto;
            }

            &:hover {
              opacity: 0.8;
            }
          }
        }
        .tweet_column {
          width: 90%;
          display: flex;
          flex-direction: column;
          margin: 5px;
          box-sizing: border-box;
          .tweet_user {
            color: #0085ad;
            margin: 5px;
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            .twitter_user_name {
              color: #0085ad;
              font-weight: bold;
            }
            .twitter_user_screen_name {
              color: #a5a9ab;
              margin-left: 5px;
            }
          }
          .tweet_content {
            margin: 5px;
          }
          .tweet_datetime {
            margin: 5px;
            color: #a5a9ab;
          }
        }
      }
    }
  }

  .friends_list {
    width: 100%;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    align-items: center;
    justify-content: flex-start;
    padding: 20px 0;
    box-sizing: border-box;
    margin-bottom: -5px;
    .friend_number {
      width: 50px;
      height: 50px;
      border: 1px solid #ccc;
      border-radius: 5px;
      background-color: #efe9e5;
      font-size: 1.5em;
      font-weight: bold;
      margin-right: 5px;
      margin-bottom: 5px;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      cursor: pointer;
      color: #4a4a4a;
      &:hover {
        color: rgba(74, 74, 74, 0.8);
      }
    }
    .friend_icon {
      overflow: hidden;
      margin-right: 5px;
      margin-bottom: 5px;
      cursor: pointer;
      width: 50px;
      height: 50px;
      &:hover {
        opacity: 0.8;
      }
      img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
      }
      .noimage {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #efe9e5;
      }
    }
  }
}

@media all and (max-width: 480px) {
  .event-modal-container {
    max-width: 300px;
    min-width: 300px;
    max-height: 80vh;
    overflow-y: scroll;
    .tweet_list {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      box-sizing: border-box;
      .tweet_item {
        display: flex;
        flex-direction: row;
        box-sizing: border-box;
        &:not(:last-child) {
          border-bottom: 1px solid #ccc;
        }
        .friend_column {
          width: 10%;
          display: flex;
          flex-direction: column;
          box-sizing: border-box;
          margin: 5px;
          .profile_icon {
            margin-top: 3px;
            overflow: hidden;
            img {
              border-radius: 50%;
              width: 30px;
              height: auto;
            }
          }
        }
        .tweet_column {
          width: 90%;
          display: flex;
          flex-direction: column;
          margin: 5px;
          box-sizing: border-box;
          .tweet_user {
            color: #0085ad;
            margin: 5px;
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            .twitter_user_name {
              color: #0085ad;
              font-weight: bold;
            }
            .twitter_user_screen_name {
              color: #a5a9ab;
              margin-left: 5px;
            }
          }
          .tweet_content {
            margin: 5px;
          }
          .tweet_datetime {
            margin: 5px;
            color: #a5a9ab;
          }
        }
      }
    }
  }

  .friends_list {
    width: 100%;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    align-items: center;
    justify-content: flex-start;
    padding: 20px 0 0;
    box-sizing: border-box;
    margin-bottom: -5px;
    .friend_number {
      width: 30px;
      height: 30px;
      border: 1px solid #ccc;
      border-radius: 5px;
      background-color: #efe9e5;
      font-size: 1em;
      font-weight: bold;
      margin-right: 4px;
      margin-bottom: 5px;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      cursor: pointer;
    }
    .friend_icon {
      overflow: hidden;
      margin-right: 4px;
      margin-bottom: 5px;
      cursor: pointer;
      width: 30px;
      height: 30px;
      img {
        width: 30px;
        height: 30px;
        border-radius: 50%;
      }
      .noimage {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: #efe9e5;
      }
    }
  }
}
</style>
