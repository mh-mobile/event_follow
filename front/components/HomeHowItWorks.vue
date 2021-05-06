<template lang="pug">
.home_how_it_works
  .how_it_works_content
    .how_it_works_description(v-if="$device.isDesktop")
      div
        | Twitterでフォローしている友達がシェアしたツイート
      div
        | に基づいて、イベント情報を発見します
    .how_it_works_description(v-else)
      div
        | Twitterでフォローしている友達がシェアしたツイートに基づいて、イベント情報を発見します
 
</template>

<style lang="scss" scoped>
.home_how_it_works {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: center;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  padding-top: 20px;
  padding-bottom: 40px;

  .how_it_works_content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    .how_it_works_description {
      width: 100%;
      font-size: 0.9em;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: center;
      box-sizing: border-box;
      -moz-box-sizing: border-box;
      -webkit-box-sizing: border-box;
    }
  }
}
</style>
