<template lang="pug">
.home_twitter_login
  a(href="/auth/twitter" class="twitter_login_button") Twitterで始める
</template>

<style lang="scss" scoped>
.home_twitter_login {
  width: 100%;
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;

  .twitter_login_button {
    background: #218af5;
    color: #fff;
    font-size: 1em;
    font-weight: bold;
    padding: 15px 40px;
    border-radius: 10px;
    cursor: pointer;

    &::before {
      content: "";
      display: inline-block;
      width: 40px;
      height: 40px;
      background-image: url("~@/assets/twitter_logo.png");
      background-size: contain;
      vertical-align: middle;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
