import PrivacyPolicyContent from "./PrivacyPolicyContent"

export default {
  title: "PrivacyPolicyContent",
  component: PrivacyPolicyContent,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { PrivacyPolicyContent },
  template: `<PrivacyPolicyContent v-bind="$props" /> `
})

export const Default = Template.bind({})
