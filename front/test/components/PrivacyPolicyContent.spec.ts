import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import PrivacyPolicyContent from "@/components/PrivacyPolicyContent.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("PrivacyPolicyContent.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(PrivacyPolicyContent, {
      localVue
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
