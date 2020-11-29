<template lang="pug">
  .friends_list
    .friend_number(@click="openModal")
      | {{ friendsNumber }}
    
    .friend_icon(v-for="(userId, index) in userIdsArray" :key="`placeholder-${index}`" v-show="friends.length == 0")
      .noimage
    .friend_icon(v-for="(friend, index) in displayable_friends" :key="`frineds-${index}`" v-show="friends.length > 0")
      a(:href="friend | friend_screen_name" target="_blank")
        img(:src="friend.profile_image")

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        Loading(v-show="isLoading")
        ul.tweet_list(v-show="!isLoading")
          li.tweet_item(v-for="tweet in tweets")
            .friend_column
              .profile_icon
                a(:href="tweet.user | friend_screen_name" target="_blank")
                  img(:src="tweet.user.profile_image")
            .tweet_column
              .tweet_user
                .twitter_user_name
                  | {{ tweet.user.name }} 
                .twitter_user_screen_name
                  | @{{ tweet.user.screen_name }} 
              .tweet_content(v-auto-link)
                | {{ tweet.text }}
              .tweet_datetime
                | {{ tweet.tweeted_at | dateFormat }}
</template>

<script>
import Modal from './modal.vue'
import Loading from './loading.vue'
export default {
  components: { Modal, Loading },
  props: ["eventId", "userIds", "friendsNumber"],
  data() {
    return {
      modal: false,
      tweets: [],
      friends: [],
      maxFriendsLength: 12
    }
  },
  computed: {
    isLoading() {
      return this.tweets.length == 0
    },
    userIdsArray() {
      return this.userIds.split(",")
    },
    displayable_friends() {
      if (this.friends.length > this.maxFriendsLength) {
        return this.friends.slice(0, this.maxFriendsLength)
      }

      return this.friends
    }
  },
  methods: {
    openModal() {
      this.modal = true

      if (this.isLoading) {
        fetch(`/api/following_tweets.json?event_id=${this.eventId}`, {
          method: "GET",
          headers: {
            "X-Requested-With": "XMLHttpRequest",
          },
          credentials: "same-origin",
          redirect: "manual"
        }).then(response => {
          return response.json()  
        }).then(json => {
          this.tweets = json
        }).catch(error => {
          console.log("Failed to parsing", error)
        })
      }
    },
    closeModal() {
      this.modal = false
    },
  },
  mounted() {
    fetch(`/api/friendships.json?user_ids=${this.userIds}`, {
      method: "GET",
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
      credentials: "same-origin",
      redirect: "manual"
    }).then(response => {
      return response.json()  
    }).then(json => {
      this.friends = json
    }).catch(error => {
      console.log("Failed to parsing", error)
    })
  },
  filters: {
    dateFormat: function(value) {
      const date = new Date(value)
      const year = String(date.getFullYear());
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hour = String(date.getHours()).padStart(2, "0")
      const minute = String(date.getMinutes()).padStart(2, "0") 
      return `${year}/${month}/${day} ${hour}:${minute}`  
    },
    friend_screen_name: function(value) {
      return `https://twitter.com/${value.screen_name}`
    }
  },
  directives: {
    "auto-link": {
      inserted(el) {
        el.innerHTML = el.innerHTML.replace(
          /(https?:\/\/[a-zA-Z0-9\-_.:@!~*'(¥);/?&=+$,%#]+)/g,
          '<a href="$1" target="_blank">$1</a>'
        )
        el.innerHTML = el.innerHTML.replace(/([@#])([\w]+)/gi, (_, prefix, word) => {
          const text = prefix + word
          const route = prefix === "@" ? word : `hashtag/${word}`
          return `<a href="https://twitter.com/${route}" target="_blank">${text}</a>`
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .event-modal-container {
    max-width: 30em;
    min-width: 30em;
    height: auto;

    .tweet_list {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      box-sizing: border-box;
      overflow-y: scroll;

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
            border-radius: 50%;
            width: 50px;
            height: 50px;
            overflow: hidden;
          }
        }

        .tweet_column {
          width: 90%;
          display: flex;
          flex-direction: column;
          margin: 5px;
          box-sizing: border-box;

          .tweet_user {
            height: 20px;
            color: #0085ad;
            margin: 5px;
            display: flex;
            flex-direction: row;

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
    height: 80px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: flex-start;
    padding: 20px 5px;
    box-sizing: border-box;

    .friend_number {
      width: 50px;
      height: 50px;
      border: 1px solid #ccc;
      border-radius: 5px;
      background-color: #f3f4f7;
      font-size: 1.5em;
      font-weight: bold;
      margin-left: 10px;
      margin-right: 10px;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      cursor: pointer;
    }

    .friend_icon {
      overflow: hidden;
      padding-right: 5px;
      cursor: pointer;

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

</style>
