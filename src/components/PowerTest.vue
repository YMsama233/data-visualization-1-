<template>
  <h2><a href="https://d3js.org" target="_blank" ><center>D3力导向图@JOJO的奇妙冒险人物关系图</center></a></h2>
  <div id="graph-chart-container"></div>
</template>

<script>
import { defineComponent } from 'vue';
import axios from "axios";
import * as d3 from "d3";

var color=d3.schemeCategory10;


export default defineComponent({
  mounted() {      
    axios.get("./a.json").then((res) => {
                this.drawGraphChart(res.data);
            });        
    },
    methods:{
      drawGraphChart(graph){
            var w=window.screen.width;
            var h=window.screen.height; 
            w=w*0.98;
            h=h*0.8;
            var svg=d3.select("#graph-chart-container")
                        .append("svg")
                        .attr("width",w)
                        .attr("height",h);

            // var forceSimulation = d3.forceSimulation()
            //                         .force("link",d3.forceLink())
            //                         .force("charge",d3.forceManyBody().strength(-400))
            //                         .force("center",d3.forceCenter(w/2,h/2));
            var forceSimulation = d3.forceSimulation()
                              .force("center",d3.forceCenter(w/2,h/2))
                              .force("charge",d3.forceManyBody().strength(-360))
                              .force("link",d3.forceLink().distance(160));	

            forceSimulation.nodes(graph.nodes)
                            .on("tick");
            
            forceSimulation.force("link")
                            .links(graph.links);
                            
            var link=svg.selectAll(".link")
                        .data(graph.links)
                        .join("line")
                        .attr("class","link")
                        .style("stroke-width",2)
                        .style("stroke",d=>d.color)
                        .style("opacity",0.6);
            console.log(link);

            var node=svg.selectAll(".node")
                        .data(graph.nodes)
                        .join("circle")
                        .attr("r",16)
                        .style("fill",(d,i)=>color[i%10])
                        .call(drag()); 
            console.log(node);        

            forceSimulation.on("tick",()=>{
                link.attr("x1",d=>d.source.x)
                    .attr("y1",d=>d.source.y)
                    .attr("x2",d=>d.target.x)
                    .attr("y2",d=>d.target.y);
                node.attr("cx",d=>d.x)
                    .attr("cy",d=>d.y);
                edges_text.attr("x",d=>(d.source.x + d.target.x) / 2 )
                            .attr("y",d=>(d.source.y + d.target.y) / 2 );
                texts.attr("x",d=>d.x)
                        .attr("y",d=>d.y);
            })

            var edges_text = svg.selectAll(".linetext")
                            .data(graph.links)
                            .join("text")
                            .attr("class","linetext")
                            .text(d=>d.value)
                            .attr("fill",d=>d.color)
                            .attr("dy",200)
                            .style("stroke","black")
                            .style("stroke-width",0.2)
                            .style("font-size",14);	   


            var texts=svg.selectAll(".forceText")
                        .data(graph.nodes)
                        .join("text")
                        .attr("class","forceText")
                        .style("stroke",(d,i)=>color[i%10])
                        .style("font-size","15px")
                        .attr("text-anchor","middle")
                        .attr("dy",30)
                        .text(d=>d.name);

            function drag()
            {
                function dragstarted(event,d){
                    if(!event.active)   forceSimulation.alphaTarget(0.3).restart();
                    d.fx=d.x;
                    d.fy=d.y;
                }
                function dragged(event,d){
                    d.fx=event.x;
                    d.fy=event.y;
                }
                function dragended(event,d){
                    if(!event.active)   forceSimulation.alphaTarget(0);
                    d.fx=null;
                    d.fy=null;
                }
                return d3.drag()
                            .on("start",dragstarted)
                            .on("drag",dragged)
                            .on("end",dragended);
            }
      }
  }
})
</script>


