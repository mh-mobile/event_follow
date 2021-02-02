import { createLocalVue, mount } from "@vue/test-utils"
import VueCompositionApi from "@vue/composition-api"
import EventSortFilter from "@/components/EventSortFilter.vue"

const localVue = createLocalVue()
localVue.use(VueCompositionApi)
describe("EventSortFilter.vue", () => {
  it("sort=friends_number_order&time=past_8_hours", async () => {
    const wrapper = mount(EventSortFilter, {
      localVue,
      propsData: {
        eventSortType: "friends_number_order",
        friendsFilterType: "three_or_more_friends"
      }
    })
    await wrapper.find(".event_header_sort_filter").trigger("click")
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("sort=friends_number_order&time=past_24_hours", async () => {
    const wrapper = mount(EventSortFilter, {
      localVue,
      propsData: {
        eventSortType: "friends_number_order",
        friendsFilterType: "past_24_hours"
      }
    })
    await wrapper.find(".event_header_sort_filter").trigger("click")
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("sort=recent_order&friends=one_or_more_friends", async () => {
    const wrapper = mount(EventSortFilter, {
      localVue,
      propsData: {
        eventSortType: "recent_order",
        friendsFilterType: "one_or_more_friends"
      }
    })
    await wrapper.find(".event_header_sort_filter").trigger("click")
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("sort=created_order&friends=two_or_more_friends", async () => {
    const wrapper = mount(EventSortFilter, {
      localVue,
      propsData: {
        eventSortType: "created_order",
        friendsFilterType: "two_or_more_friends"
      }
    })
    await wrapper.find(".event_header_sort_filter").trigger("click")
    expect(wrapper.html()).toMatchSnapshot()
  })

  it("sort=closeness_order&friends=two_or_more_friends", async () => {
    const wrapper = mount(EventSortFilter, {
      localVue,
      propsData: {
        eventSortType: "closeness_order",
        friendsFilterType: "two_or_more_friends"
      }
    })
    await wrapper.find(".event_header_sort_filter").trigger("click")
    expect(wrapper.html()).toMatchSnapshot()
  })
})
