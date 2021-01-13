export const useModalHelper = () => {
  const setScrollEnabled = (isEnabled: boolean) => {
    const htmlElement = document.querySelector("html")
    if (isEnabled) {
      htmlElement?.classList.remove("scroll_disable")
    } else {
      htmlElement?.classList.add("scroll_disable")
    }
  }

  return {
    setScrollEnabled
  }
}
