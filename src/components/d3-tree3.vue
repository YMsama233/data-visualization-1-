<template>
    <div id="d3tree-container">
    </div>
    </template>
    
    
    
    <script>
    import { defineComponent } from 'vue';
    import axios from "axios";
    import * as d3 from "d3";
    
    
    export default defineComponent({
        mounted() {      
        axios.get("./tree.json").then((res) => {
                    this.drawGraphChart(res.data);
                });        
        },
        methods:{
          drawGraphChart(data){
              var w=window.screen.width;
              var h=window.screen.height; 
              w=w*0.9;
              h=h*0.9;
              var color=d3.schemeCategory10;
              var svg=d3.select("#d3tree-container")
                      .append("svg")
                      .attr("width",w)
                      .attr("height",h);
              var radius=w/2;
              var tree=d3.tree().size([2*Math.PI,radius-350]);
  
              var root=tree(d3.hierarchy(data));
  
              var links=root.links();
  
              var nodes=root.descendants();
              
              console.log(nodes)
              var gc=svg.append("g")
                      .attr("transform","translate("+(w/2)+","+(h/2)+")")
                      
              var lines=gc.selectAll("path")
                          .data(links)
                          .join("path")
                          .attr("fill","none")
                          .attr("stroke","#00f")
                          .attr("stroke-width","1")
                          .attr("d",d3.linkRadial().angle(d=>d.x).radius(d=>d.y));
  
              var circle=gc.selectAll("circle")
                          .data(nodes)
                          .join("circle")
                          .attr("r",d=>d.height*2+2)
                          .style("fill",d=>color[d.height%10])
                          .attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);
  
              console.log(lines,circle)
  
              var nodetxt=gc.selectAll("text") 
                          .data(nodes)
                          .join("text")
                          .attr("x",d=>Math.cos(d.x-Math.PI/2)*d.y)
                          .attr("y",d=>Math.sin(d.x-Math.PI/2)*d.y)
                          //.attr("text-anchor","middle")
                          .attr("font-size","12")
                          .attr("fill","green")
                          .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                          .attr("text-anchor",d => !d.children?"start" : "end")                      
                          .text(d=>d.data.name);         
                console.log(nodetxt)
          }
      }
    })
    </script>
     <style>
     #d3tree-container{

         float:left;
        
     }
     .title{
         height:100px;
         width:100%;
         position:relative;
         left:40%;
         font-family:微软雅黑;
         font-size:40px;
         font-weight:bold;
     }
     .menu{
         float:left;
         position: fixed;
         left:70%;
         top:30%;

     }
 </style>
 