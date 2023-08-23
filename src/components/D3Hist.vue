<template>
    <div class="hello">
      <h1>{{ msg }}</h1>
      <p>
        <a href="https://d3js.org" target="_blank" rel="noopener">D3JS</a>.
      </p>
    </div>
  </template>
  
  <script>
  import axios from "axios"
  export default {
    mounted(){
        axios.get("./alphabet.json").then(res => {
            console.log(res.data);
        })
    }
}
  </script>

  
  <!-- Add "scoped" attribute to limit CSS to this component only -->
  <style scoped>
  h3 {
    margin: 40px 0 0;
  }
  ul {
    list-style-type: none;
    padding: 0;
  }
  li {
    display: inline-block;
    margin: 0 10px;
  }
  a {
    color: #42b983;
  }
  </style>
  