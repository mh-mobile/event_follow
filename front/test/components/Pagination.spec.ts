import { createLocalVue, shallowMount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import Pagination from "@/components/Pagination.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)

let totalPages: number
let pageWindow: number

describe("Pagination.vue", () => {
  beforeEach(() => {
    totalPages = 100
    pageWindow = 2
  })

  it("currentPage=2", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 2
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=3", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 3
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=4", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 4
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=10", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 10
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=97", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 97
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=98", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 98
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=99", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 99
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("currentPage=100", () => {
    const wrapper = shallowMount(Pagination, {
      localVue,
      propsData: {
        totalPages,
        pageWindow,
        currentPage: 100
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
