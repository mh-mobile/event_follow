import HomeHowItWorks from './HomeHowItWorks'

export default {
  title: 'HomeHowItWorks',
  component: HomeHowItWorks,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { HomeHowItWorks },
  template: `<HomeHowItWorks v-bind="$props" /> `
})

export const Default = Template.bind({})
