export default ({ app }: { app: any }, inject: any) => {
  inject("checkUrl", (url: string) => {
    return url.match(/^https?:\/\//)
  })
}
