<template lang="pug">
div
  .content_wrapper
    .header
      .container
        .logo
          a(href="/home")
           img(src="@/assets/logo_transparent.png")
  .home_container
    HomeConcept
    HomeTwitterLogin
    HomeHowItWorks
  .footer
    .container
      .copyright
        | &copy; event follow
      a(href="/" class="terms") 利用規約
      a(href="/" class="privacy_policy") プライバシーポリシー
</template>

<script lang="ts">
import HomeConcept from '@/components/HomeConcept.vue'
import HomeTwitterLogin from '@/components/HomeTwitterLogin.vue'
import HomeHowItWorks from '@/components/HomeHowItWorks.vue'
import { defineComponent } from '@nuxtjs/composition-api'
export default defineComponent({
  components: {
    HomeConcept,
    HomeTwitterLogin,
    HomeHowItWorks
  }
})
</script>

<style lang="scss" scoped>
.header {
  padding: 5px;
  background-color: #efe9e5;

  .container {
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

  .container {
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
      margin-right: auto;
      color: #000;
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
