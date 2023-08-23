<template><div>
    <div class="title">贵州省行政区划</div>
    <div id="d3tree-container"></div>
    <form class="menu" action="">
        <div class="treet">
            <input type="radio" class="tree-type1" name="treetype" value="t" checked="true">Tree 
            <input type="radio" class="tree-type2" name="treetype" value="rt">Radial Tree
        </div>
        <br>
        <div class="direction">
            <input type="radio" class="dir1" name="tree-dir" value="vertical" checked="true">Vertical
            <input type="radio" class="dir2" name="tree-dir" value="horizontal">Horizontal
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
                var svg=d3.select("#d3tree-container")
                                    .append("svg")
                                    .attr("width",w*0.9)
                                    .attr("height",h);
                var radius=w/2;
                var tree=d3.cluster().size([w*0.7,h*0.7]);
                var root=tree(d3.hierarchy(data));
                var links=root.links();
                var nodes=root.descendants();
                console.log(nodes,links)
                var gc=svg.append("g")
                        .attr("transform","translate("+(w/2000)+","+(h/8)+")")                

                var type2=d3.selectAll(".tree-type2")
                    .on("click",function(){  
                        console.log(type2.attr("value"))
                        drawsvgr();
                        
                    })
                var type1=d3.selectAll(".tree-type1")
                    .on("click",function(){  
                            console.log(type1.attr("value"))  
                            drawsvgt();
                    })

                var dict1=d3.selectAll(".dir1")
                    .on("click",function(){  
                            console.log(dict1.attr("value"))  
                            drawsvgv();
                    })    
                function drawsvgt(){
                        svg.selectAll('*').remove();
            
                        
                        tree=d3.cluster().size([w*0.7,h*0.7]);
                        root=tree(d3.hierarchy(data));
                        links=root.links();
                        nodes=root.descendants();
                        console.log(nodes,links)
                        gc=svg.append("g")
                                .attr("transform","translate("+(w/2000)+","+(h/8)+")")
                        
                }
                    function drawsvgv(){
                        var lines=gc.selectAll("path")
                                    .data(links)
                                    .join("path")
                                    .attr("fill","none")
                                    .attr("stroke","#00f")
                                    .attr("stroke-width","1")
                                    .attr("d",d3.linkVertical()          //d3.linkHorizontal()
                                                .x(d=>d.x)
                                                .y(d=>d.y));

                        var circle=gc.selectAll("circle")
                                    .data(nodes)
                                    .join("circle")
                                    .attr("cx",d=>d.x)
                                    .attr("cy",d=>d.y)
                                    .attr("r",d=>d.height*4+4)
                                    .style("fill",d=>color[d.height%10])
                                    //.attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);

                        console.log(lines,circle)

                        var nodetxt=gc.selectAll("text") 
                                    .data(nodes)
                                    .join("text")
                                    .attr("x",d=>d.x+4)
                                    .attr("y",function(d){
                                        if(d.height==2){
                                            return d.y-10
                                        }
                                        if(d.height==1){
                                            return d.y-6
                                        }
                                        if(d.height==0){
                                            return d.y+2
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
                                    .attr("transform",d=>`rotate(90,${d.x},${d.y})`)
                                    //.attr("text-anchor",d => !d.children?"start" : "end")                      
                                    .text(d=>d.data.name);         
                            console.log(nodetxt)
                        }
              

            function drawsvgr(){
                    svg.selectAll('*').remove();
                    
                    
                    tree=d3.cluster().size([2*Math.PI,radius-350]);

                    root=tree(d3.hierarchy(data));

                    links=root.links();

                    nodes=root.descendants();
                    
                    console.log(nodes,links)
                    gc=svg.append("g")
                            .attr("transform","translate("+(w/2)+","+(h/2)+")")
                            
                    // var lines=gc.selectAll("path")
                    //             .data(links)
                    //             .join("path")
                    //             .attr("fill","none")
                    //             .attr("stroke","#00f")
                    //             .attr("stroke-width","1")
                    //             .attr("d",d3.linkRadial().angle(d=>d.x).radius(d=>d.y));

                    // var circle=gc.selectAll("circle")
                    //             .data(nodes)
                    //             .join("circle")
                    //             .attr("r",d=>d.height*2+2)
                    //             .style("fill",d=>color[d.height%10])
                    //             .attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);

                    // console.log(lines,circle)

                    // var nodetxt=gc.selectAll("text") 
                    //             .data(nodes)
                    //             .join("text")
                    //             .attr("x",d=>Math.cos(d.x-Math.PI/2)*d.y)
                    //             .attr("y",d=>Math.sin(d.x-Math.PI/2)*d.y)
                    //             //.attr("text-anchor","middle")
                    //             .attr("font-size","12")
                    //             .attr("fill","green")
                    //             .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                    //             .attr("text-anchor",d => !d.children?"start" : "end")                      
                    //             .text(d=>d.data.name);         
                    // console.log(nodetxt)
              }
              
             
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
    