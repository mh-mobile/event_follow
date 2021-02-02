import VueCompositionApi from "@vue/composition-api"
import { createLocalVue } from "@vue/test-utils"
import { useModalHelper } from "@/compositions/modal_helper"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)

describe("modal_helper.spec.ts", () => {
  it("disable scroll", () => {
    const { setScrollEnabled } = useModalHelper()
    setScrollEnabled(false)

    const htmlElement = document.querySelector("html")
    expect(htmlElement?.classList.contains("scroll_disable")).toEqual(true)
  })

  it("enable scroll", () => {
    const { setScrollEnabled } = useModalHelper()
    setScrollEnabled(false)
    setScrollEnabled(true)

    const htmlElement = document.querySelector("html")
    expect(htmlElement?.classList.contains("scroll_disable")).toEqual(false)
  })
})
