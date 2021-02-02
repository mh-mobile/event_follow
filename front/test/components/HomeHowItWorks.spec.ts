import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import HomeHowItWorks from "@/components/HomeHowItWorks.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("HomeHowItWorks.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(HomeHowItWorks, {
      localVue
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
