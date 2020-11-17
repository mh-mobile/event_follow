<template lang="pug">
  .example-modal-window
    .event_header_sort_filter(@click="openModal")
      | 3+ frineds

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        .event-modal-header
          .event-modal-left
            | Sort
          .event-modal-center
          .event-modal-right
            | Filter
        .event-modal-content
          .event-modal-left.event-modal-sort
            select
              option(value="Friend数")
                | Friend数
              option(value="新着順")
                | 新着順
              option(value="投稿順")
                | 投稿順
              option(value="開催が近い順")
                | 開催が近い順
          .event-modal-center
            | ×
          .event-modal-right.event-modal-sort
            select
              option(value="過去8時間")
                | 過去8時間
              option(value="過去24時間")
                | 過去24時間
              option(value="過去2日")
                | 過去2日
              option(value="過去3日")
                | 過去3日
              option(value="過去4日")
                | 過去4日
              option(value="過去5日")
                | 過去5日
              option(value="過去6日")
                | 過去6日
              option(value="過去1週間")
                | 過去1週間
              option(value="All")
                | All
 
        .event-modal-footer
  </div>
</template>

<script>
import Modal from './modal.vue'
export default {
  components: { Modal },
  data() {
    return {
      modal: false,
      message: ""
    }
  },
  methods: {
    openModal() {
      this.modal = true
    },
    closeModal() {
      this.modal = false
    },
    doSend() {
      if (this.message.length > 0) {
        alert(this.message)
        this.message = ""
        this.closeModal()
      } else {
        alert('メッセージを入力してください')
      }
    }
  }
}
</script>

<style lang="scss">
  .event-modal-container {
    max-width: 30em;
    min-width: 30em;

    .event-modal-header {
      display: flex;
      width: 100%;
      align-items: center;
      justify-content: center;
      font-size: 1.2em;
      font-weight: bold;
      color: #9f9fa3;
    }

    .event-modal-content {
      display: flex;
      width: 100%;
      align-items: center;
      justify-content: center;
      height: 70px;
    }

    .event-modal-footer {
      display: flex;
      width: 100%;
      align-items: center;
      justify-content: center;
    }

    .event-modal-left {
      width: 45%;
      display: flex;
      justify-content: center;
    }

    .event-modal-center {
      width: 10%;
      display: flex;
      justify-content: center;
      font-size: 2em;
    }

    .event-modal-right {
      width: 45%;
      display: flex;
      justify-content: center;

    }

    .event-modal-sort, .event-modal-filter {
      position: relative;
      &::after {
        content: "";
        position: absolute;
        width: 12px;
        height: 12px;
        border: 2px solid;
        top: calc(50% - 4px);
        right: 5px;
        border-color:  transparent transparent #565656 #565656;
        transform: rotate(-45deg) translateY(-50%);
      }

      select {
        width: 100%;
        height: 50px;
        padding-left: 10px;
        padding-right: 10px;
        outline: none;
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        font-size: 1em;
        border-radius: 5px
      }
    }
  }
</style>
