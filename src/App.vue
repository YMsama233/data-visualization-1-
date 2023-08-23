<template>
  <D3Cluster msg="THREE.JS@Vue3"/>
</template>

<script>


import D3Cluster from './components/TestEx.vue';


export default{
  name: 'App',           
  components: {
    D3Cluster
}
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
