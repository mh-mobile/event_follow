import HomeTwitterLogin from './HomeTwitterLogin'

export default {
  title: 'HomeTwitterLogin',
  component: HomeTwitterLogin,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { HomeTwitterLogin },
  template: `<HomeTwitterLogin v-bind="$props" /> `
})

export const Default = Template.bind({})
