import EventSortFilter from './EventSortFilter'

export default {
  title: 'EventSortFilter',
  component: EventSortFilter,
  parameters: {
    layout: "centered"
  },
  argTypes: {
    eventSortType: {
      control: {
        type: "inline-radio",
        options: ["friends_number_order", "recent_order", "created_order", "closeness_order"]
      }
    },
    timeFilterType: {
      control: {
        type: "inline-radio",
        options: [
          "past_8_hours",
          "past_24_hours",
          "past_2_days",
          "past_3_days",
          "past_4_days",
          "past_5_days",
          "past_6_days",
          "past_1_weeks",
          "past_all",
        ]
      }
    },
    friendsFilterType: {
      control: {
        type: "inline-radio",
        options: [
          "one_or_more_friends",
          "two_or_more_friends",
          "three_or_more_friends",
          "four_or_more_friends",
          "five_or_more_friends"
        ]
      }
    }
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { EventSortFilter },
  template: `<EventSortFilter v-bind="$props" /> `
})

export const FriendsNumberSort = Template.bind({})
FriendsNumberSort.storyName = "Friend数順"
FriendsNumberSort.args = {
  eventSortType: "friends_number_order",
  timeFilterType: "past_8_hours"
}

export const RecentOrderSort = Template.bind({})
RecentOrderSort.storyName = "新着順"
RecentOrderSort.args = {
  eventSortType: "recent_order",
  friendsFilterType: "one_or_more_friends"
}

export const CreatedOrderSort = Template.bind({})
CreatedOrderSort.storyName = "投稿順"
CreatedOrderSort.args = {
  eventSortType: "created_order",
  friendsFilterType: "one_or_more_friends"
}

export const ClosenestOrderSort = Template.bind({})
ClosenestOrderSort.storyName = "開催が近い順"
ClosenestOrderSort.args = {
  eventSortType: "closeness_order",
  friendsFilterType: "one_or_more_friends"
}
