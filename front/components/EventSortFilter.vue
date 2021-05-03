<template lang="pug">
  .example-modal-window
    .event_header_sort_filter(@click="openModal")
      | {{ getCurrentConditionLabel }}

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        form(action="/events" method="GET" id="js-sort-filter-form")
          .event-modal-sort
            .event-modal-label
              | Sort by
            .event-modal-value
              select(v-model="selectedSortCondition" @change="selectedSortConditionChanged($event)" name="sort")
                option(v-for="item in eventSortConditionItems" :value="item.value" :key="item.value")
                  | {{ item.name }}
          .event-modal-center
            .event-modal-label
            .event-modal-value
              | ×
          .event-modal-filter
            .event-modal-label
              | Filter by
            .event-modal-value
              select(v-model="selectedTimeFilterCondition" v-show="isFrinedsNumberSortCondition" @change="selectedTimeFilterConditionChanged" name="time")
                option(v-for="item in timeFilterTypeItems" :value="item.value" :key="item.value")
                  | {{ item.name }}
              select(v-model="selectedFriendsFilterCondition" v-show="!isFrinedsNumberSortCondition" @change="selectedFriendsFilterConditionChanged" name="friends")
                option(v-for="item in friendsFilterTypeItems" :value="item.value" :key="item.value")
                  | {{ item.name }}
</template>

<script>
import Modal from "@/components/Modal.vue"

import { useEventSortFilter } from "@/compositions/event_sort_filter_helper"
import {
  defineComponent,
  toRefs,
  watch,
  onMounted
} from "@nuxtjs/composition-api"

export default defineComponent({
  components: { Modal },
  props: {
    eventSortType: {
      type: String,
      default: ""
    },
    timeFilterType: {
      type: String,
      default: ""
    },
    friendsFilterType: {
      type: String,
      default: ""
    }
  },
  setup(props, { root }) {
    const {
      eventSortConditionItems,
      timeFilterTypeItems,
      friendsFilterTypeItems,
      isFrinedsNumberSortCondition,
      getCurrentConditionLabel,
      changeSortFilterCondition,
      openModal,
      closeModal,
      updateSortCondition,
      updateTimeFilterCondition,
      updateFriendsFilterCondition,
      state
    } = useEventSortFilter()

    const selectedSortConditionChanged = () => {
      changeSortFilterCondition(root.$router)
    }

    const selectedTimeFilterConditionChanged = () => {
      changeSortFilterCondition(root.$router)
    }

    const selectedFriendsFilterConditionChanged = () => {
      changeSortFilterCondition(root.$router)
    }

    watch(
      () => props.eventSortType,
      async (newValue) => {
        updateSortCondition(newValue)
      }
    )

    watch(
      () => props.timeFilterType,
      async (newValue) => {
        updateTimeFilterCondition(newValue)
      }
    )

    watch(
      () => props.friendsFilterType,
      async (newValue) => {
        updateFriendsFilterCondition(newValue)
      }
    )

    onMounted(() => {
      updateSortCondition(props.eventSortType)
      updateTimeFilterCondition(props.timeFilterType)
      updateFriendsFilterCondition(props.friendsFilterType)
    })

    return {
      ...toRefs(state),
      eventSortConditionItems,
      timeFilterTypeItems,
      friendsFilterTypeItems,
      isFrinedsNumberSortCondition,
      getCurrentConditionLabel,
      openModal,
      closeModal,
      selectedSortConditionChanged,
      selectedTimeFilterConditionChanged,
      selectedFriendsFilterConditionChanged
    }
  }
})
</script>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .event_header_sort_filter {
    font-size: 1.5em;
    font-weight: bold;
    position: relative;
    padding-right: 24px;
    cursor: pointer;

    &::after {
      content: "";
      position: absolute;
      width: 12px;
      height: 12px;
      border: 2px solid;
      top: calc(50% - 4px);
      right: 0;
      border-color: transparent transparent #565656 #565656;
      transform: rotate(-45deg) translateY(-50%);
    }
  }

  .event-modal-container {
    max-width: 30em;
    min-width: 30em;

    form {
      display: flex;
      flex-direction: row;
      margin-bottom: 10px;

      .event-modal-center {
        width: 1.5em;
        display: flex;
        flex-direction: column;
        justify-content: center;
        font-size: 2em; 

        .event-modal-label {
          display: flex;
          flex-direction: row;
          height: 40%;
          width: 100%;
        }

        .event-modal-value {
          height: 60%;
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
        } 
      }

      .event-modal-sort,
      .event-modal-filter {
        width: calc((100%-1.5em)/2);
        position: relative;
        display: flex;
        flex-direction: column;

        .event-modal-label {
          height: 40%;
          width: 100%;
          display: flex;
          flex-direction: row;
          justify-content: center;
          align-items: center;
          font-size: 1.2em;
          font-weight: bold;
          color: #9f9fa3;
          white-space: nowrap;
          padding: 5px;
        }

        .event-modal-value {
          height: 60%;
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          position: relative;

          &::after {
            content: "";
            position: absolute;
            width: 12px;
            height: 12px;
            border: 2px solid;
            top: calc(50% - 5px);
            right: 5px;
            border-color: transparent transparent #565656 #565656;
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
            border-radius: 5px;
          }
        }
      }
    }
  }
}

@media all and (max-width: 480px) {
  .event_header_sort_filter {
    font-size: 1em;
    font-weight: bold;
    padding: 10px;
    cursor: pointer;
    position: relative;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    background-color: #ffffff;

    &::before {
      content: "";
      display: inline-block;
      width: 1.5em;
      height: 1.5em;
      background: url("~@/assets/search_icon.svg");
      background-size: contain;
    }

  }

  .event-modal-container {
    width: 300px;

    form {
      display: flex;
      flex-direction: column;
      justify-content: center;
      margin-bottom: 10px;
      align-items: flex-start;

      .event-modal-center {
        font-size: 2em; 
        align-self: center;

        .event-modal-value {
          height: 1em;
          display: flex;
          flex-direction: row;
          align-items: center;
        }  
      }

      .event-modal-sort,
      .event-modal-filter {
        width: 100%;

        .event-modal-label {
          height: 40%;
          font-size: 1.2em;
          font-weight: bold;
          color: #9f9fa3;
          padding: 2px 0;
          display: inline-block;
        }

        .event-modal-value {
          height: 60%;
          position: relative;

          &::after {
            content: "";
            position: absolute;
            width: 12px;
            height: 12px;
            border: 2px solid;
            top: calc(50% - 5px);
            right: 5px;
            border-color: transparent transparent #565656 #565656;
            transform: rotate(-45deg) translateY(-50%);
          }
          select {
            height: 50px;
            width: 100%;
            padding-left: 10px;
            padding-right: 10px;
            outline: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            font-size: 1em;
            border-radius: 5px;
          }
        }
      }
    }
  }
}
</style>
