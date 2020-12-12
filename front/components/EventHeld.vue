<template lang="pug">
.event_held
  .event_date
    | 12/24
  .event_start
    | 開催
</template>

<style lang="scss" scoped>
.event_held {
  width: 100px;
  height: 100px;
  border: 1px solid #cccccc;
  background-color: #f3f4f7;
  border-radius: 5px;
  display: flex;
  flex-direction: column;
  justify-items: center;

  .event_date {
    font-size: 2em;
    height: 50%;
    text-align: center;
  }

  .event_start {
    font-size: 1.5em;
    height: 50%;
    text-align: center;
  }
}
</style>
