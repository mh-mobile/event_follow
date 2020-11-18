<template lang="pug">
  .friends_list
    .friend_number(@click="openModal")
      | 11
    .friend_icon
      img(src="https://dummyimage.com/100x100/8db9ca/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/84bd00/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/1cc7d0/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/d20963/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/ffc30e/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/0c3866/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/b4a996/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/ff4d00/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/aea500/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/6539b7/fff.png")
    .friend_icon
      img(src="https://dummyimage.com/100x100/70b29c/fff.png")

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        ul.tweet_list
          li.tweet_item(v-for="tweet in tweets")
            .friend_column
              .profile_icon
                img(src="https://pbs.twimg.com/profile_images/1212203727597129729/ET2dFF9i_400x400.jpg")
            .tweet_column
              .tweet_user
                .twitter_user_name
                  | {{ tweet.name }} 
                .twitter_user_screen_name
                  | {{ tweet.screen_name }} 
              .tweet_content
                | {{ tweet.content }}

  </div>
</template>

<script>
import Modal from './modal.vue'
export default {
  components: { Modal },
  data() {
    return {
      modal: false,
      tweets: [
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "VS Code Conferenceに参加するぞ!"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: 1Dayイベント、VS Code Conference Japan の開催は来週土曜日です。私は、初心者向けハンズオンと、Dev Containerの話をします。"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: 今週末は2つ大型イベントがあるので絶賛準備中Personal computer 11/21(土) 10:00 VS Code Conference Japan 11/22(日) 10:00 サイエンスアゴラ2020"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japan(2020/11/21 10:00～) ハイパー便利な Visual Studio Code の勉強会です。Webなのでご気軽に参加しよう！俺もLT枠で登壇すっぞー(そのためこの時間まで資料作成中)"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japanに参加を申し込みました！ https://vscode.connpass.com/event/184441/?utm_campaign=event_participate_to_follower&utm_source=notifications&utm_medium=twitter #vscodejp"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: このイベントでLTするんだけれど、参加者600人超えなのか…Webとはいえ緊張するじゃないか。今までせいぜい10人ぐらいの前でしかLTやったことないんだぞ。 https://vscode.connpass.com/event/184441/"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japan https://vscode.connpass.com/event/184441/ #vscodejp VScodeの5周年のイベント（？）があるんだ どんな感じなのか気になる！Flushed faceSparkles でも私はこの日は見れないですが。。Crying cat face"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japanに参加を申し込みました！ https://vscode.connpass.com/event/184441/?utm_campaign=event_participate_to_follower&utm_source=notifications&utm_medium=twitter #vscodejp"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japan に参加を申し込みました！ https://vscode.connpass.com/event/184441/?utm_campaign=event_participate_to_follower&utm_source=notifications&utm_medium=twitter #vscodejp"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japanハンズオントラック に参加を申し込みました！ https://vscode.connpass.com/event/192720/?utm_campaign=event_participate_to_follower&utm_source=notifications&utm_medium=twitter #vscodejp"
        },
        {
          name: "mh",
          screen_name: "@mh_mobiler",
          content: "RT: VS Code Conference Japanハンズオントラック に参加を申し込みました！ https://vscode.connpass.com/event/192720/?utm_campaign=event_participate_to_follower&utm_source=notifications&utm_medium=twitter #vscodejp"
        },
      ]
    }
  },

  methods: {
    openModal() {
      this.modal = true
    },
    closeModal() {
      this.modal = false
    }
  }
}
</script>

<style lang="scss" scoped>
  .event-modal-container {
    max-width: 30em;
    min-width: 30em;
    height: 30em;

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
        }
      }
    }
  }

  .friend_number {
    cursor: pointer;
  }

  .friend_icon {
    cursor: pointer;
  }


</style>
