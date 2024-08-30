<template>
  <HelloWorld :val="myRef" />
</template>

<script>
import HelloWorld from "./components/HelloWorld.vue";
import { ref } from "vue";

export default {
  name: "App",
  components: {
    HelloWorld,
  },
  setup() {
    // Create a reactive ref
    const myRef = ref("this is reactive text stored in a ref");

    // Expose the ref globally
    window.myRef = myRef;

    // Method to update ref from within the component
    const injectIntoExposedFunction = (val) => {
      myRef.value = val;
    };

    // Return ref and method for template access
    return { myRef, injectIntoExposedFunction };
  },
};
</script>
