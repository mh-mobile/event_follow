<template lang="pug">
div
  Nuxt 
  .footer
    .footer-container
      .copyright
        | &copy; event follow
      .github
        a(href="https://github.com/mh-mobile/event_follow" target="_blank")
          img(src="@/assets/github_logo.png")
      .agreement_container
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

  a {
    color: #004276;
    &:hover {
      color: rgba(0, 66, 118, 0.8);
    }
  }
}

@media all and (min-width: 480px) {
  .footer {
    padding: 5px;
    background-color: #efe9e5;
    height: 160px;

    .footer-container {
      max-width: 50rem;
      margin: 20px auto;
      padding: 5px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      box-sizing: border-box;
      -moz-box-sizing: border-box;
      -webkit-box-sizing: border-box;
      position: relative;

      .copyright {
        margin-right: 5px;
        color: #000;
      }

      .github {
        width: 20px;
        height: auto;
        padding-top: 10px;
        padding-bottom: 10px;
        &:hover {
          opacity: 0.8;
        }
      }

      .agreement_container {
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
        .terms {
          color: #000;
          padding-right: 10px;
          &:hover {
            opacity: 0.8;
          }
        }

        .privacy_policy {
          color: #000;
          &:hover {
            opacity: 0.8;
          }
        }
      }
    }
  }
}

@media all and (max-width: 480px) {
  .footer {
    padding: 5px;
    background-color: #efe9e5;
    font-size: 0.8em;

    .footer-container {
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
        margin-right: 10px;
        color: #000;
      }

      .privacy_policy {
        color: #000;
      }
    }
  }
}
</style>
