import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import HomeConcept from "@/components/HomeConcept.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("HomeConcept.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(HomeConcept, {
      localVue
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
