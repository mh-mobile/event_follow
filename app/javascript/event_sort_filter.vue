<template lang="pug">
  .example-modal-window
    .event_header_sort_filter(@click="openModal")
      | {{ getCurrentConditionLabel }}

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        form(action="/" method="GET" id="js-sort-filter-form")
          .event-modal-header
            .event-modal-left
              | Sort
            .event-modal-center
            .event-modal-right
              | Filter
          .event-modal-content
              .event-modal-left.event-modal-sort
                select(v-model="selected_sort_condition" @change="selectedSortConditionChanged($event)" name="sort")
                  option(v-for="item in event_sort_condition_items" :value="item.value" :key="item.value")
                    | {{ item.name }}
              .event-modal-center
                | ×
              .event-modal-right.event-modal-sort
                select(v-model="selected_time_filter_condition" v-show="isFrinedsNumberSortCondition" @change="selectedTimeFilterConditionChanged" name="time")
                  option(v-for="item in time_filter_type_items" :value="item.value" :key="item.value")
                    | {{ item.name }}
                select(v-model="selected_friends_filter_condition" v-show="!isFrinedsNumberSortCondition" @change="selectedFriendsFilterConditionChanged" name="friends")
                  option(v-for="item in friends_filter_type_items" :value="item.value" :key="item.value")
                    | {{ item.name }}
  </div>
</template>

<script>
import Modal from './modal.vue'
export default {
  components: { Modal },
  props: {
    eventSortType: String,
    timeFilterType: String,
    friendsFilterType: String
  },
  data() {
    return {
      modal: false,
      message: "",
      selected_sort_condition: "friends_number_order",
      selected_time_filter_condition: "past_8_hours",
      selected_friends_filter_condition: "one_or_more_friends",
      event_sort_condition_items: [
        {
          name: "Friend数",
          value: "friends_number_order"
        },
        {
          name: "新着順",
          value: "recent_order" 
        },
        {
          name: "投稿順",
          value: "created_order"
        },
        {
          name: "開催が近い順",
          value: "closeness_order"
        }
      ],
      time_filter_type_items: [
        {
          name: "過去8時間",
          value: "past_8_hours"
        },
        {
          name: "過去24時間",
          value: "past_24_hours"
        },
        {
          name: "過去2日",
          value: "past_2_days"
        },
        {
          name: "過去3日",
          value: "past_3_days"
        },
        {
          name: "過去4日",
          value: "past_4_days"
        },
        {
          name: "過去5日",
          value: "past_5_days"
        },
        {
          name: "過去6日",
          value: "past_6_days"
        },
        {
          name: "過去1週間",
          value: "past_1_weeks"
        },
        {
          name: "All",
          value: "past_all"
        }
      ],
      friends_filter_type_items: [
        {
          name: "Friends 1+",
          value: "one_or_more_friends"
        },
        {
          name: "Friends 2+",
          value: "two_or_more_friends"
        },
        {
          name: "Friends 3+",
          value: "three_or_more_friends"
        },
        {
          name: "Friends 4+",
          value: "four_or_more_friends"
        },
        {
          name: "Friends 5+",
          value: "five_or_more_friends"
        }
      ]
    }
  },
  created() {
    this.selected_sort_condition = this.eventSortType
    this.selected_time_filter_conditio = this.timeFilterType
    this.selected_friends_filter_condition = this.friendsFilterType
  },
  computed: {
    isFrinedsNumberSortCondition: function() {
      return this.selected_sort_condition == "friends_number_order"
    },
    getCurrentConditionLabel: function() {
      const sortConditionLabel = this.event_sort_condition_items.find((item) => {
        return item.value == this.selected_sort_condition
      }).name
      if (this.isFrinedsNumberSortCondition) {
        const timeFilterConditionLabel = this.time_filter_type_items.find((item) => {
          return item.value == this.selected_time_filter_condition
        }).name
        return `${sortConditionLabel} × ${timeFilterConditionLabel}`
      } else {
        const friendsFilterConditionLabel = this.friends_filter_type_items.find((item) => {
          return item.value == this.selected_friends_filter_condition
        }).name
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
    },
    selectedSortConditionChanged(event) {
      document.getElementById("js-sort-filter-form").submit()
    },
    selectedTimeFilterConditionChanged(event) {
      document.getElementById("js-sort-filter-form").submit()
    },
    selectedFriendsFilterConditionChanged(event) {
      document.getElementById("js-sort-filter-form").submit()
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
