import Loading from "./Loading"

export default {
  title: "Loading",
  component: Loading,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Loading },
  template: `<Loading v-bind="$props" /> `
})

export const Default = Template.bind({})
