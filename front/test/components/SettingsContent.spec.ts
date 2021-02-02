import { createLocalVue, mount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import SettingsContent from "@/components/SettingsContent.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("SettingsContent.vue", () => {
  it("renders html correctly", () => {
    const wrapper = mount(SettingsContent, {
      localVue
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
