import FriendsList from "./FriendsList"

export default {
  title: "FriendsList",
  component: FriendsList,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { FriendsList },
  template: `<FriendsList v-bind="$props" /> `
})

export const Default = Template.bind({})
Default.args = {
  eventId: 1,
  userIds: "111,222,3333",
  friendsNumber: 3
}
