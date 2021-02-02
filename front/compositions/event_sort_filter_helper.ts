import { computed, reactive } from "@nuxtjs/composition-api"
import { useModalHelper } from "@/compositions/modal_helper"

type ConditionItem = {
  name: String
  value: String
}

export const useEventSortFilter = () => {
  const { setScrollEnabled } = useModalHelper()

  const eventSortConditionItems: ConditionItem[] = [
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
  ]

  const timeFilterTypeItems: ConditionItem[] = [
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
  ]

  const friendsFilterTypeItems: ConditionItem[] = [
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

  const validateCondition = (
    sortCondition: string,
    timeFilterCondition: string,
    friendsFilterCondition: string
  ) => {
    if (sortCondition === "") {
      return false
    }

    if (
      sortCondition === "friends_number_order" &&
      timeFilterCondition === ""
    ) {
      return false
    }

    if (sortCondition === "recent_order" && friendsFilterCondition === "") {
      return false
    }

    if (sortCondition === "created_order" && friendsFilterCondition === "") {
      return false
    }

    if (sortCondition === "closeness_order" && friendsFilterCondition === "") {
      return false
    }

    return true
  }

  const getCurrentConditionLabel = computed(() => {
    if (
      !validateCondition(
        state.selectedSortCondition,
        state.selectedTimeFilterCondition,
        state.selectedFriendsFilterCondition
      )
    ) {
      return ""
    }

    const sortConditionLabel = eventSortConditionItems.find((item) => {
      return item.value === state.selectedSortCondition
    })?.name

    if (state.selectedSortCondition === "friends_number_order") {
      const timeFilterConditionLabel = timeFilterTypeItems.find((item) => {
        return item.value === state.selectedTimeFilterCondition
      })?.name
      return `${sortConditionLabel} × ${timeFilterConditionLabel}`
    }

    const friendsFilterConditionLabel = friendsFilterTypeItems.find(
      (item: ConditionItem) => {
        return item.value === state.selectedFriendsFilterCondition
      }
    )?.name
    return `${sortConditionLabel} × ${friendsFilterConditionLabel}`
  })

  const openModal = () => {
    state.modal = true
    setScrollEnabled(false)
  }

  const closeModal = () => {
    state.modal = false
    setScrollEnabled(true)
  }

  const changeSortFilterCondition = (router: any) => {
    router.replace(
      `/events?sort=${state.selectedSortCondition}&time=${state.selectedTimeFilterCondition}&friends=${state.selectedFriendsFilterCondition}`
    )
    state.modal = false
    setScrollEnabled(true)
  }

  const updateSortCondition = (newValue: string) => {
    state.selectedSortCondition = newValue
  }

  const updateTimeFilterCondition = (newValue: string) => {
    state.selectedTimeFilterCondition = newValue
  }

  const updateFriendsFilterCondition = (newValue: string) => {
    state.selectedFriendsFilterCondition = newValue
  }

  return {
    state,
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
    updateFriendsFilterCondition
  }
}
