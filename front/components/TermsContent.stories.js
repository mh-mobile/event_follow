import TermsContent from "./TermsContent"

export default {
  title: "TermsContent",
  component: TermsContent,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { TermsContent },
  template: `<TermsContent v-bind="$props" /> `
})

export const Default = Template.bind({})
