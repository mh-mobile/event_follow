<template lang="pug">
.loader-wrapper
  .loader.is-loading
</template>

<style lang="scss" scoped>
.loader-wrapper {
  width: 100%;
  height: 15em;
  display: flex;
  background-color: #ffffff;
  border-radius: 7px;
  justify-content: center;
  align-items: center;
  position: relative;
  .loader {
    height: 50px;
    width: 50px;
  }
  .is-loading {
    position: relative;
  }
}
</style>
