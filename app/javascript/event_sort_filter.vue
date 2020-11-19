<template lang="pug">
  .example-modal-window
    .event_header_sort_filter(@click="openModal")
      | {{ getCurrentConditionLabel }}

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
            select(v-model="selected_sort_condition")
              option(v-for="item in event_sort_condition_items" :value="item.value" :key="item.value")
                | {{ item.name }}
          .event-modal-center
            | ×
          .event-modal-right.event-modal-sort
            select(v-model="selected_time_filter_condition" v-if="isFrinedsNumberSortCondition")
              option(v-for="item in time_filter_type_items" :value="item.value" :key="item.value")
                | {{ item.name }}
            select(v-model="selected_friends_filter_condition" v-if="!isFrinedsNumberSortCondition")
              option(v-for="item in friends_filter_type_items" :value="item.value" :key="item.value")
                | {{ item.name }}
  </div>
</template>

<script>
import Modal from './modal.vue'
export default {
  components: { Modal },
  data() {
    return {
      modal: false,
      message: "",
      selected_sort_condition: 0,
      selected_time_filter_condition: 0,
      selected_friends_filter_condition: 0,
      event_sort_condition_items: [
        {
          name: "Friend数",
          value: 0
        },
        {
          name: "新着順",
          value: 1
        },
        {
          name: "投稿順",
          value: 2
        },
        {
          name: "開催が近い順",
          value: 3
        }
      ],
      time_filter_type_items: [
        {
          name: "過去8時間",
          value: 0
        },
        {
          name: "過去24時間",
          value: 1
        },
        {
          name: "過去2日",
          value: 2
        },
        {
          name: "過去3日",
          value: 3
        },
        {
          name: "過去4日",
          value: 4
        },
        {
          name: "過去5日",
          value: 5
        },
        {
          name: "過去6日",
          value: 6
        },
        {
          name: "過去1週間",
          value: 7
        },
        {
          name: "All",
          value: 8
        }
      ],
      friends_filter_type_items: [
        {
          name: "Friends 1+",
          value: 0
        },
        {
          name: "Friends 2+",
          value: 1
        },
        {
          name: "Friends 3+",
          value: 2
        },
        {
          name: "Friends 4+",
          value: 3
        },
        {
          name: "Friends 5+",
          value: 4
        }
      ]
    }
  },
  computed: {
    isFrinedsNumberSortCondition: function() {
      return this.selected_sort_condition == 0
    },
    getCurrentConditionLabel: function() {
      const sortConditionLabel = this.event_sort_condition_items[this.selected_sort_condition].name
      if (this.selected_sort_condition == 0) {
        const timeFilterConditionLabel = this.time_filter_type_items[this.selected_time_filter_condition].name
        return `${sortConditionLabel} × ${timeFilterConditionLabel}`
      } else {
        const friendsFilterConditionLabel = this.friends_filter_type_items[this.selected_friends_filter_condition].name
        return `${sortConditionLabel} × ${friendsFilterConditionLabel}`
      }
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
