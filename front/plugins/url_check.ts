export default (_: any, inject: any) => {
  inject("checkUrl", (url: string) => {
    return url.match(/^https?:\/\//)
  })
}
