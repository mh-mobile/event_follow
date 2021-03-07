import HomeConcept from "./HomeConcept"

export default {
  title: "HomeConcept",
  component: HomeConcept,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { HomeConcept },
  template: `<HomeConcept v-bind="$props" /> `
})

export const Default = Template.bind({})
