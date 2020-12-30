<template>
  <div>
    <Nuxt :nuxt-child-key="$route.fullPath" />
  </div>
</template>

<style>

html {
  background-color: #d7d7d8;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

body {
  background-color: #d7d7d8;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  .content_wrapper {
    min-height: 100%;
    margin-bottom: -70px;
  }
}
</style>
