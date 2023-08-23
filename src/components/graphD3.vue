<template>
  <div style="width:900px;height:600px;font-family:微软雅黑;color:#000000;font-size:17px;"><div style="width:300px;float:left;text-align: center;position:relative;left:5%;top:13%;background-color: antiquewhite;opacity: 0.9;">
    <p>《JOJO的奇妙冒险》</p>
    <p>是由荒木飞吕彦创作的一系列漫画，并伴有动画、游戏、小说等衍生作品。</p>
    <p>1987年开始在《少年JUMP》上连载，2005年第七部连载时转移到了《Ultra JUMP》，目前已连载至第九部（截至2023年2月18日），单行本数量超过100卷且仍在连载中。</p>
    <p>系列作品均围绕作中人物威廉·A·齐贝林所述：「人类的赞歌是勇气的赞歌」这一精神主旨进行创作，讲述了主角乔斯达家族每代人经历的不同故事中，人们“黄金精神”（或“漆黑意志”）的发扬与传承。</p>
    <p ><a href="https://baike.baidu.com/item/JOJO%E7%9A%84%E5%A5%87%E5%A6%99%E5%86%92%E9%99%A9/4422729">数据来源：网页百科</a></p>
  </div>
    <div id="graph-chart-container" style="width:100px;height:100%;float:left">
    </div>
  </div>


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
            w=w*0.9;
            h=h*0.8;
            var img_w=70;
            var img_h=70;

            var svg=d3.select("#graph-chart-container")
                        .append("svg")
                        .attr("width",w)
                        .attr("height",h);

            var defs = svg.append("defs");
            var radius=10;
            var arrowMarker = defs.append("marker")
                                .attr("id","arrow")
                                .attr("markerUnits","strokeWidth")
                                .attr("markerWidth","8")
                                .attr("markerHeight","8")
                                .attr("viewBox","0 0 8 8")
                                .attr("refX",12+radius/8-2)   //实际是radius/strokeWidth
                                .attr("refY",2)
                                .attr("orient","auto");
            var arrow_path = "M0,1 L4,2 L0,3 L0,0";

            arrowMarker.append("path")
                       .attr("d",arrow_path);

            // var forceSimulation = d3.forceSimulation()
            //                         .force("link",d3.forceLink())
            //                         .force("charge",d3.forceManyBody().strength(-400))
            //                         .force("center",d3.forceCenter(w/2,h/2));
            var forceSimulation = d3.forceSimulation()
                              .force("center",d3.forceCenter(w/3+100,h/2-60))
                              .force("charge",d3.forceManyBody().strength(-700))
                              .force("link",d3.forceLink().distance(200));	

            forceSimulation.nodes(graph.nodes)
                            .on("tick");
            
            forceSimulation.force("link")
                            .links(graph.links);

                            
            // var link=svg.selectAll(".link")
            //             .data(graph.links)
            //             .join("line")
            //             .attr("class","link")
            //             .style("stroke-width",2)
            //             .style("stroke",(d,i)=>color[i%10])
            //             .style("opacity",0.6);
            // console.log(link);

            // var node=svg.selectAll(".node")
            //             .data(graph.nodes)
            //             .join("circle")
            //             .attr("r",16)
            //             .style("fill",(d,i)=>color[i%10])
            //             .call(drag()); 

            var path=svg.selectAll("path")// eslint-disable-line no-unused-vars
                .data(graph.links)
                .enter()
                .append("path")
                .attr("id", function(d,i) {
                    return "edgepath" +i;
                })
                .attr("class","edges")
                .attr("fill","none")
                .style("stroke-width",4)
                .attr("stroke","#666")
                .attr("marker-end","url(#arrow)"); 
            console.log(path)
            
            

            var edges_text = svg.selectAll(".edgeText")
                            .data(graph.links)
                            .join("text")
                            .append('textPath')
                            .attr("class","linetext")
                            .attr("text-anchor", "middle")//居中
                            .attr("startOffset","50%")
                            .attr('xlink:href', function(d,i) { return "#edgepath" + i; })
                            .style("font-size",18)
                            .style("font-family","微软雅黑")
                            .text(d=>d.value)
                            .attr("fill",(d,i)=>color[i%10])
                            .style("stroke","black")
                            .style("stroke-width",0.2)
                            // .style("font-size",14);	

            var node=svg.selectAll("forceCircle")
                        .data(graph.nodes)
                        .join("circle")
                        .attr("class","foeceCircle")
                        .attr("r",radius*3)
                        .style("stroke","DarkGray")
                        .style("stroke-width","1.4")
                        .attr("fill",function(d,i){
                            var defs1=svg.append("defs")
                                        .attr("id","imgdefs");
                            var catpattern = defs1.append("pattern")
                                         .attr("id", "catpattern" + i)
                                         .attr("height", 1)
                                         .attr("width", 1);
                        catpattern.append("image")
                                .attr("x", - (img_w / 2 - radius*3+5.8))
                                .attr("y", - (img_h / 2 - radius*3+3.5))
                                .attr("width", img_w+11)
                                .attr("height", img_h+6)
                                .attr("xlink:href",d.image);
                        return "url(#catpattern" + i + ")";
                        })
                        .call(drag()); 
            console.log(node);        

            forceSimulation.on("tick",()=>{
                path.attr("d", function(d) {
                    // var dx = d.target.x - d.source.x;//增量
                    // var dy = d.target.y - d.source.y;
                    return "M" + d.source.x + ","+ d.source.y + "L" + d.target.x + "," + d.target.y;
                  });         
                node.attr("cx",d=>d.x)
                    .attr("cy",d=>d.y);
                edges_text.attr("x",d=>(d.source.x + d.target.x) / 2 )
                            .attr("y",d=>(d.source.y + d.target.y) / 2 );
                texts.attr("x",d=>d.x)
                        .attr("y",d=>d.y);
            })

                 

            var texts=svg.selectAll(".forceText")
                        .data(graph.nodes)
                        .join("text")
                        .attr("class","forceText")
                        .style("fill", d=>d.color)
                        .style("stroke","black")
                        .style("stroke-width",0.2)
                        .style("font-size","23px")
                        .style("font-weight","bold")
                        .style("font-family","微软雅黑")
                        .attr("text-anchor","middle")
                        .attr("dy",50)
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
