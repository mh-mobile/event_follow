import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import TopScrollButton from "@/components/TopScrollButton.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("TopScrollButton.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(TopScrollButton, {
      localVue
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
