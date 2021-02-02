import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import EventHeld from "@/components/EventHeld.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("EventHeld.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(EventHeld, {
      localVue,
      propsData: {
        started_at: "2021-02-06T13:40:00.000Z"
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
