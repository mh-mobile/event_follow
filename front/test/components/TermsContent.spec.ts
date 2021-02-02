import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import TermsContent from "@/components/TermsContent.vue"

const localVue = createLocalVue();
localVue.use(VueCompositionApi);
describe("TermsContent.vue", () => {
  it("renders html correctly", () => {
    const wrapper = shallowMount(TermsContent, {
      localVue,
    });
    expect(wrapper.html()).toMatchSnapshot();
  });
});
