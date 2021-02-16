import EventSortFilter from './EventSortFilter'

export default {
  title: 'EventSortFilter',
  component: EventSortFilter,
  parameters: {
    layout: "centered"
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
