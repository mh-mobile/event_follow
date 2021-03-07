import Pagination from "./Pagination"

export default {
  title: "Pagination",
  component: Pagination,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Pagination },
  template: `<Pagination v-bind="$props" /> `
})

export const Default = Template.bind({})
Default.storyName = "currentPage=1"
Default.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 1
}

export const CurrentPage2 = Template.bind({})
CurrentPage2.storyName = "currentPage=2"
CurrentPage2.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 2
}

export const CurrentPage3 = Template.bind({})
CurrentPage3.storyName = "currentPage=3"
CurrentPage3.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 3
}

export const CurrentPage4 = Template.bind({})
CurrentPage4.storyName = "currentPage=4"
CurrentPage4.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 4
}

export const CurrentPage10 = Template.bind({})
CurrentPage10.storyName = "currentPage=10"
CurrentPage10.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 10
}

export const CurrentPage97 = Template.bind({})
CurrentPage97.storyName = "currentPage=97"
CurrentPage97.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 97
}

export const CurrentPage98 = Template.bind({})
CurrentPage98.storyName = "currentPage=98"
CurrentPage98.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 98
}

export const CurrentPage99 = Template.bind({})
CurrentPage99.storyName = "currentPage=99"
CurrentPage99.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 99
}

export const CurrentPage100 = Template.bind({})
CurrentPage100.storyName = "currentPage=100"
CurrentPage100.args = {
  totalPages: 100,
  pageWindow: 2,
  currentPage: 100
}
