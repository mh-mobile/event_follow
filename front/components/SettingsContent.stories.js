import SettingsContent from './SettingsContent'

export default {
  title: 'SettingsContent',
  component: SettingsContent,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { SettingsContent },
  template: `<SettingsContent v-bind="$props" /> `
})

export const Default = Template.bind({})
