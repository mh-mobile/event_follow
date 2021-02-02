<template lang="pug">
  .example-modal-window
    .event_header_sort_filter(@click="openModal")
      | {{ getCurrentConditionLabel }}

    Modal(@close="closeModal" v-if="modal")
      .event-modal-container
        form(action="/events" method="GET" id="js-sort-filter-form")
          .event-modal-header
            .event-modal-left
              | Sort by
            .event-modal-center
            .event-modal-right
              | Filter by
          .event-modal-content
              .event-modal-left.event-modal-sort
                select(v-model="selectedSortCondition" @change="selectedSortConditionChanged($event)" name="sort")
                  option(v-for="item in eventSortConditionItems" :value="item.value" :key="item.value")
                    | {{ item.name }}
              .event-modal-center
                | ×
              .event-modal-right.event-modal-sort
                select(v-model="selectedTimeFilterCondition" v-show="isFrinedsNumberSortCondition" @change="selectedTimeFilterConditionChanged" name="time")
                  option(v-for="item in timeFilterTypeItems" :value="item.value" :key="item.value")
                    | {{ item.name }}
                select(v-model="selectedFriendsFilterCondition" v-show="!isFrinedsNumberSortCondition" @change="selectedFriendsFilterConditionChanged" name="friends")
                  option(v-for="item in friendsFilterTypeItems" :value="item.value" :key="item.value")
                    | {{ item.name }}
  </div>
</template>

<script>
import Modal from "@/components/Modal.vue"
import { useModalHelper } from "@/compositions/modal_helper"
import { useEventSortFilter } from "@/compositions/event_sort_filter_helper"
import {
  defineComponent,
  computed,
  reactive,
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
    const { setScrollEnabled } = useModalHelper()
    const { 
      eventSortConditionItems,
      timeFilterTypeItems,
      friendsFilterTypeItems
    } = useEventSortFilter()

    const state = reactive({
      modal: false,
      message: "",
      selectedSortCondition: "friends_number_order",
      selectedTimeFilterCondition: "past_8_hours",
      selectedFriendsFilterCondition: "one_or_more_friends"
    })

    const isFrinedsNumberSortCondition = computed(() => {
      return state.selectedSortCondition === "friends_number_order"
    })
    const getCurrentConditionLabel = computed(() => {
      if (state.selectedSortCondition === "") {
        return ""
      }
      
      if (state.selectedSortCondition === "friends_number_order" && state.selectedTimeFilterCondition === "") {
        return ""
      }

      if (state.selectedSortCondition === "recent_order" && state.selectedFriendsFilterCondition === "") {
        return ""
      }

      if (state.selectedSortCondition === "created_order" && state.selectedFriendsFilterCondition === "") {
        return ""
      }

      if (state.selectedSortCondition === "closeness_order" && state.selectedFriendsFilterCondition === "") {
        return ""
      }

      const sortConditionLabel = eventSortConditionItems.find((item) => {
        return item.value === state.selectedSortCondition
      }).name
      if (state.selectedSortCondition === "friends_number_order") {
        const timeFilterConditionLabel = timeFilterTypeItems.find((item) => {
          return item.value === state.selectedTimeFilterCondition
        }).name
        return `${sortConditionLabel} × ${timeFilterConditionLabel}`
      } else {
        const friendsFilterConditionLabel = friendsFilterTypeItems.find(
          (item) => {
            return item.value === state.selectedFriendsFilterCondition
          }
        ).name
        return `${sortConditionLabel} × ${friendsFilterConditionLabel}`
      }
    })

    const openModal = () => {
      state.modal = true
      setScrollEnabled(false)
    }

    const closeModal = () => {
      state.modal = false
      setScrollEnabled(true)
    }

    const changeSortFilterCondition = () => {
      root.$router.replace(
        `/events?sort=${state.selectedSortCondition}&time=${state.selectedTimeFilterCondition}&friends=${state.selectedFriendsFilterCondition}`
      )
      state.modal = false
      setScrollEnabled(true)
    }

    const selectedSortConditionChanged = () => {
      changeSortFilterCondition()
    }

    const selectedTimeFilterConditionChanged = () => {
      changeSortFilterCondition()
    }

    const selectedFriendsFilterConditionChanged = () => {
      changeSortFilterCondition()
    }

    watch(
      () => props.eventSortType,
      async (newValue) => {
        state.selectedSortCondition = newValue
      }
    )

    watch(
      () => props.timeFilterType,
      async (newValue) => {
        state.selectedTimeFilterCondition = newValue
      }
    )

    watch(
      () => props.friendsFilterType,
      async (newValue) => {
        state.selectedFriendsFilterCondition = newValue
      }
    )

    onMounted(() => {
      state.selectedSortCondition = props.eventSortType
      state.selectedFriendsFilterCondition = props.friendsFilterType
      state.selectedTimeFilterCondition = props.timeFilterType
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
  .event-modal-sort,
  .event-modal-filter {
    position: relative;
    &::after {
      content: "";
      position: absolute;
      width: 12px;
      height: 12px;
      border: 2px solid;
      top: calc(50% - 4px);
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
</style>
