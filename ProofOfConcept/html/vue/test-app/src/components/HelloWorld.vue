<script setup>
import { defineProps } from "vue";
defineProps({
  val: String,
});
// Function to emit a custom event
const emitCustomEvent = () => {
  const event = new CustomEvent("vue-event", {
    detail: { message: message.value },
  });

  // Dispatch the event on the window object
  window.dispatchEvent(event);
};
</script>

<template>
  <div class="vue">
    <h1>This is a Vue.js app</h1>
    <p id="testVueInject">{{ val }}</p>
    <button @click="emitCustomEvent">Click me</button>
  </div>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.vue {
  border: 2px solid blue;
  padding: 1rem;
}
</style>
