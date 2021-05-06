<template lang="pug">
.home_concept
  .logo
    img(src="@/assets/logo_transparent.png")
  div
    | 興味のある技術
  div
    | イベントを見逃さない
</template>

<style lang="scss" scoped>
@media all and (min-width: 480px) {
  .home_concept {
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    font-size: 46px;
    font-weight: bold;
    line-height: 58px;
    margin-bottom: 20px;
    color: #52648d;

    .logo {
      padding-top: 100px;
      padding-bottom: 100px;
      width: 250px;
      height: auto;
    }
  }
}

@media all and (max-width: 480px) {
  .home_concept {
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    font-size: 1.8em;
    font-weight: bold;
    margin-bottom: 20px;
    color: #52648d;
    line-height: 40px;

    .logo {
      padding-top: 50px;
      padding-bottom: 30px;
      width: 150px;
      height: auto;
    } 
  }
}
</style>
