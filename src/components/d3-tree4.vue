<template><div>
    <div class="title">贵州省行政区划</div>
    <div id="d3tree-container"></div>
    <form class="menu">
        <div class="tree">
            <input type="radio" name="tree-type" value="tree">Tree 
            <input type="radio" name="tree-type" value="Rtree">Radial Tree
        </div>
        <br>
        <div class="direction">
            <input type="radio" name="tree-dir" value="vertical">Vertical
            <input type="radio" name="tree-dir" value="horizontal">Horizontal
        </div>
        <br>
        <div class="extent">
            <input type="range" name="tree-extent" min="0" max="360" step="1">Extent
        </div>
        <br>
        <div class="cluster">
            <select name="links">
                <option value="cluster">Cluster</option>
                <option value="tidy">Tidy</option>
            </select>
        </div>
    </form>

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
              var type=d3.select("tree-type")
              if (type=="tree")
                console.log(1111)
              console.log(type)

              var svg=d3.select("#d3tree-container")
                      .append("svg")
                      .attr("width",w*0.9)
                      .attr("height",h);
            
              var tree=d3.cluster().size([h,w*0.6]);
  
              var root=tree(d3.hierarchy(data));

              var links=root.links();
              var nodes=root.descendants();
              
              console.log(nodes,links)
              var gc=svg.append("g")
                      .attr("transform","translate("+(w/20)+","+(h/1000)+")")
                      
              var lines=gc.selectAll("path")
                          .data(links)
                          .join("path")
                          .attr("fill","none")
                          .attr("stroke","#00f")
                          .attr("stroke-width","1")
                          .attr("d",d3.linkHorizontal()          //d3.linkHorizontal()
                                    .x(d=>d.y)
                                    .y(d=>d.x));
  
              var circle=gc.selectAll("circle")
                          .data(nodes)
                          .join("circle")
                          .attr("cx",d=>d.y)
                          .attr("cy",d=>d.x)
                          .attr("r",d=>d.height*4+4)
                          .style("fill",d=>color[d.height%10])
                          //.attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);
  
              console.log(lines,circle)
  
              var nodetxt=gc.selectAll("text") 
                          .data(nodes)
                          .join("text")
                          .attr("x",d=>d.y+4)
                          .attr("y",function(d){
                            if(d.height==2){
                                return d.x-10
                            }
                            if(d.height==1){
                                return d.x-6
                            }
                            if(d.height==0){
                                return d.x+2
                            }
                            })
                          //.attr("text-anchor","middle")
                          .attr("font-size",function(d){
                            if(d.height==2){
                                return 30
                            }
                            if(d.height==1){
                                return 20
                            }
                            if(d.height==0){
                                return 8
                            }
                          })
                          .attr("fill","green")
                         // .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                          //.attr("text-anchor",d => !d.children?"start" : "end")                      
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
            width:800px;
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
    