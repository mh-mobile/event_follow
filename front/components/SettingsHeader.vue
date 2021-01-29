<template lang="pug">
.event_list_header
  .event_header_top
    .event_header_info
      | 設定
</template>

<style lang="scss" scoped>
.event_list_header {
  display: flex;
  flex-direction: column;
  margin-bottom: 10px;
  .event_header_top {
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    align-items: center;

    .event_header_info {
      margin-right: auto;
      font-size: 2em;
      font-weight: bold;
    }
  }
}
</style>
