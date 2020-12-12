<template lang="pug">
.home_how_it_works
  .how_it_works_label
    | How It Works
  .how_it_works_content
    .how_it_works_description
      | Twitterでフォローしている友達がシェアしたツイートに基づいて、イベント情報を発見します
    .how_it_works_picture
      img(src="@/assets/how_it_works_picture.png")
</template>

<style lang="scss" scoped>
.home_how_it_works {
  width: 100%;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;

  .how_it_works_label {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 20px;
    font-size: 1.5em;
    font-weight: bold;
  }

  .how_it_works_content {
    display: flex;
    flex-direction: row;
    align-items: flex-center;

    .how_it_works_description {
      width: 50%;
      font-size: 1.2em;
      padding: 10px;
      display: flex;
      align-items: center;
    }

    .how_it_works_picture {
      width: 50%;
      height: auto;
      padding: 10px;
    }
  }
}
</style>
