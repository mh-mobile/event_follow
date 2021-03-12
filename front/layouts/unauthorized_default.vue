<template lang="pug">
div
  .header
    .header-container
      .logo
        a(href="/home")
          img(src="@/assets/logo_transparent.png")
  Nuxt 
  .footer
    .footer-container
      .copyright
        | &copy; event follow
      .github
        a(href="https://github.com/mh-mobile/event_follow" target="_blank")
          img(src="@/assets/github_logo.png")
      a(href="/terms" class="terms") 利用規約
      a(href="/privacy_policy" class="privacy_policy") プライバシーポリシー
</template>

<style lang="scss">
body,
html {
  background-color: #d7d7d8;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

.header {
  padding: 5px;
  background-color: #efe9e5;

  .header-container {
    max-width: 50rem;
    margin: 0 auto;
    padding: 5px;
    height: 70px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: flex-end;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    position: relative;

    .logo {
      margin-right: auto;
      width: 100px;
      height: auto;
    }
  }
}

.footer {
  padding: 5px;
  background-color: #efe9e5;

  .footer-container {
    max-width: 50rem;
    margin: 0 auto;
    padding: 5px;
    height: 70px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: flex-end;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    position: relative;

    .copyright {
      margin-right: 5px;
      color: #000;
    }

    .github {
      margin-right: auto;
      width: 20px;
      height: 20px;
    }

    .terms {
      margin-right: 50px;
      color: #000;
    }

    .privacy_policy {
      color: #000;
    }
  }
}
</style>
