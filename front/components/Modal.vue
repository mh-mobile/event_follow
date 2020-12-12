<template lang="pug">
  transition(name="modal" appear)
    .modal.modal-overlay(@click.self="$emit('close')")
      .modal-window
        .modal-window-content
          slot
</template>

<style lang="scss" scoped>
.modal-overlay {
  display: flex;
  align-items: center;
  justify-content: center;;
  position: fixed;
  z-index: 30;
  top: 0;
  left: 0;
  height: 100%;
  width: 100%;
  background: rgba(0, 0, 0, 0.4);
}
.modal-window {
  background: #fff;
  border-radius: 4px;
  overflow: hidden;
}
.modal-window-content {
  padding: 10px 20px;
}
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.4s;
  .modal-window {
    transition: opacity 0.4s, transform 0.4s;
  }
}
.modal-leave-active {
  transition: opacity 0.6s ease 0.4s;
}
.modal-enter, .modal-leave-to {
  opacity: 0;
  .modal-window {
    opacity: 0;
    transform: translateY(-20px);
  }
}
</style>
