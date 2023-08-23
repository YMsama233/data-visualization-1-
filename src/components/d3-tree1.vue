<template>
    <div class="home">
    <div class="title"><h1 class="t">贵州省行政区划</h1></div>
    <div id="d3tree-container"></div>
    <div class="Form">
    <form class="myForm" name="myForm" action="" method="">
        <div class="radial">
            <input type="radio" class="mytree1" name="mtree" checked="true">圆形节点对齐
            <input type="radio" class="mytree2" name="mtree" >圆形层次对齐
        </div><br>
        <div class="tree">
            <input type="radio" class="mytree3" name="mtree" >树形节点对齐
            <input type="radio" class="mytree4" name="mtree" >树形层次对齐
        </div>
        <br>
        <span>0%</span>
        <input type="range" id="tree-radius" name="tree-radius" min="0" max="360" step="1">
        <span>100%</span>
    </form>
    </div>
    <div class="intro"><p>贵州，简称“黔”或“贵”，是中华人民共和国省级行政区，省会贵阳市。</p>
        <p>北接四川省和重庆市，东毗湖南省、南邻广西壮族自治区、西连云南省。</p>
        <p>境内地势西高东低，自中部向北、东、南三面倾斜，属亚热带季风气候。</p>
        <p>全省总面积17.62万平方千米，共有6个地级市、3个自治州 ，全省常住人口3852万人。</p>
        <p>贵州省地处西南内陆地区腹地，是西南地区交通枢纽，长江经济带重要组成部分。</p>
        <p>全国首个国家级大数据综合试验区，国家生态文明试验区，内陆开放型经济试验区。</p>
        <p>历史代表文化为“黔贵文化”，中国古人类的发祥地和中国古文化的发源地之一。</p>
        <p text-align="center">数据来源：百度百科</p>
    </div>
    </div>
    <div class="name" style="color: rgba(0, 255, 255, 0.636);font-size: 25px;position: fixed;top:15%;left:90%;">20数科张劲涛</div>
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

            var svg=d3.select("#d3tree-container")
                        .append("svg")
                        .attr("width",w)
                        .attr("height",h);
            var radius=w/2;
            d3.selectAll(".mytree1")
                    .on("click",function(myForm){  
                        console.log(myForm.mtree)
                        svg.selectAll('*').remove();
                        var tree=d3.cluster().size([2*Math.PI,radius-350])
                        var root=tree(d3.hierarchy(data));
                        var links=root.links();
                        var nodes=root.descendants();
                        var gc=svg.append("g")
                                .attr("transform","translate("+(w/2-40)+","+(h/2)+")");
                        var lines=gc.selectAll("path")
                            .data(links)
                            .join("path")
                            .attr("fill","none")
                            .attr("stroke","rgb(176,224,230)")
                            .attr("stroke-width","0.8")
                            .attr("d",d3.linkRadial().angle(d=>d.x).radius(d=>d.y));
                        var circle=gc.selectAll("circle")
                                    .data(nodes)
                                    .join("circle")
                                    .attr("r",function(d){
                                        if(d.height==2)
                                            return 20
                                        else if(d.height==1)
                                            return 12
                                        else if(d.height==0)
                                            return 5
                                    })
                                    .style("fill",function(d){
                                        if(d.height==2)
                                            return "rgb(81,19,124)"
                                        else if(d.height==1)
                                            return "rgb(182,55,122)"
                                        else if(d.height==0)
                                            return "rgb(251,135,98)"
                                    })
                                    .attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);
                        console.log(lines,circle)
                        var nodetxt=gc.selectAll("text") 
                                    .data(nodes)
                                    .join("text")
                                    .attr("x",d=>Math.cos(d.x-Math.PI/2)*d.y)
                                    .attr("y",d=>Math.sin(d.x-Math.PI/2)*d.y)
                                    //.attr("text-anchor","middle")
                                    .attr("font-size",function(d){
                                        if(d.height==2){
                                            return 30
                                        }
                                        if(d.height==1){
                                            return 18
                                        }
                                        if(d.height==0){
                                            return 15
                                        }
                                    })
                                    .attr("fill","rgb(240,255,255)")
                                    .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                                    .attr("text-anchor",d => !d.children?"start" : "end")                      
                                    .text(d=>d.data.name);         
                            console.log(nodetxt)        
                    })
                    d3.selectAll(".mytree2")
                    .on("click",function(myForm){  
                        console.log(myForm.mtree)
                        svg.selectAll('*').remove();
                        var tree=d3.tree().size([2*Math.PI,radius-350])
                        var root=tree(d3.hierarchy(data));
                        var links=root.links();
                        var nodes=root.descendants();
                        var gc=svg.append("g")
                                .attr("transform","translate("+(w/2-40)+","+(h/2)+")");
                        var lines=gc.selectAll("path")
                            .data(links)
                            .join("path")
                            .attr("fill","none")
                            .attr("stroke","rgb(176,224,230)")
                            .attr("stroke-width","0.8")
                            .attr("d",d3.linkRadial().angle(d=>d.x).radius(d=>d.y));
                        var circle=gc.selectAll("circle")
                                    .data(nodes)
                                    .join("circle")
                                    .attr("r",function(d){
                                        if(d.height==2)
                                            return 20
                                        else if(d.height==1)
                                            return 12
                                        else if(d.height==0)
                                            return 5
                                    })
                                    .style("fill",function(d){
                                        if(d.height==2)
                                            return "rgb(81,19,124)"
                                        else if(d.height==1)
                                            return "rgb(182,55,122)"
                                        else if(d.height==0)
                                            return "rgb(251,135,98)"
                                    })
                                    .attr("transform",d =>`rotate(${d.x*180/Math.PI-90}) translate(${d.y},0)`);
                        console.log(lines,circle)
                        var nodetxt=gc.selectAll("text") 
                                    .data(nodes)
                                    .join("text")
                                    .attr("x",d=>Math.cos(d.x-Math.PI/2)*d.y)
                                    .attr("y",d=>Math.sin(d.x-Math.PI/2)*d.y)
                                    //.attr("text-anchor","middle")
                                    .attr("font-size",function(d){
                                        if(d.height==2){
                                            return 30
                                        }
                                        if(d.height==1){
                                            return 18
                                        }
                                        if(d.height==0){
                                            return 15
                                        }
                                    })
                                    .attr("fill","rgb(240,255,255)")
                                    .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                                    .attr("text-anchor",d => !d.children?"start" : "end")                      
                                    .text(d=>d.data.name);         
                            console.log(nodetxt)        
                    })
                    d3.selectAll(".mytree3")
                    .on("click",function(myForm){  
                        console.log(myForm.mtree)
                        svg.selectAll('*').remove();
                        var tree=d3.cluster().size([h*0.9,w*0.7]);
  
                        var root=tree(d3.hierarchy(data));

                        var links=root.links();
                        var nodes=root.descendants();
                        
                        console.log(nodes,links)
                        var gc=svg.append("g")
                                .attr("transform","translate("+(w/10)+","+(h/1000)+")");
                                
                        var lines=gc.selectAll("path")
                                .data(links)
                                .join("path")
                                .attr("fill","none")
                                .attr("stroke","rgb(176,224,230)")
                                .attr("stroke-width","0.8")
                                    .attr("d",d3.linkHorizontal()          //d3.linkHorizontal()
                                                .x(d=>d.y)
                                                .y(d=>d.x));
            
                        var circle=gc.selectAll("circle")
                                    .data(nodes)
                                    .join("circle")
                                    .attr("cx",d=>d.y)
                                    .attr("cy",d=>d.x)
                                    .attr("r",d=>d.height*4+4)
                                    .style("fill",function(d){
                                        if(d.height==2)
                                            return "rgb(81,19,124)"
                                        else if(d.height==1)
                                            return "rgb(182,55,122)"
                                        else if(d.height==0)
                                            return "rgb(251,135,98)"
                                    })
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
                                    .attr("fill","rgb(240,255,255)")
                                    // .attr("transform",d=>`rotate(${d.x*180/Math.PI-90},${Math.cos(d.x-Math.PI/2)*d.y},${Math.sin(d.x-Math.PI/2)*d.y})`)
                                    //.attr("text-anchor",d => !d.children?"start" : "end")                      
                                    .text(d=>d.data.name);         
                        console.log(nodetxt)
                    })
                    d3.selectAll(".mytree4")
                    .on("click",function(myForm){  
                        console.log(myForm.mtree)
                        svg.selectAll('*').remove();
                        var tree=d3.cluster().size([w*0.7,h*0.7]);
  
                        var root=tree(d3.hierarchy(data));

                        var links=root.links();
                        var nodes=root.descendants();
                        
                        console.log(nodes,links)
                        var gc=svg.append("g")
                                .attr("transform","translate("+(w/10)+","+(h/8)+")");
                                
                        var lines=gc.selectAll("path")
                                .data(links)
                                .join("path")
                                .attr("fill","none")
                                .attr("stroke","rgb(176,224,230)")
                                .attr("stroke-width","0.8")
                                    .attr("d",d3.linkVertical()          //d3.linkHorizontal()
                                                .x(d=>d.x)
                                                .y(d=>d.y));
            
                        var circle=gc.selectAll("circle")
                                    .data(nodes)
                                    .join("circle")
                                    .attr("cx",d=>d.x)
                                    .attr("cy",d=>d.y)
                                    .attr("r",d=>d.height*4+4)
                                    .style("fill",function(d){
                                        if(d.height==2)
                                            return "rgb(81,19,124)"
                                        else if(d.height==1)
                                            return "rgb(182,55,122)"
                                        else if(d.height==0)
                                            return "rgb(251,135,98)"
                                    })
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
                                    .attr("fill","rgb(240,255,255)")
                                    .attr("transform",d=>`rotate(90,${d.x},${d.y})`)
                                    //.attr("text-anchor",d => !d.children?"start" : "end")                      
                                    .text(d=>d.data.name);         
                        console.log(nodetxt)
                    })
                        
                        
                        
                    
                }
            
        }
  })
    
    
</script>
   <style>
   .home{
    background: url("C:\\apache-tomcat-9.0.73\\webapps\\helloworld\\public\\guizhou.png");
    opacity: 1;
    width: 100%;
    height: 100%;
    position: fixed;
    background-size: 100% 100%;
   }
   .t{
    width: auto;
    position: fixed;
    left:37%;
    top:0;
    color:rgb(154, 232, 243)
   }
   .intro{
    width:700px;
    background-color: rgba(0, 0, 0, 0.411);
    color:#ffffff;
    position: relative;
    font-size: 21px;
    float:left;
    left:45%;
    top:25%;
    border: 6px solid #333;
    stroke: black;
    stroke-width: 1px;
   }
   #d3tree-container{
    position:absolute;
    float:left;
      
   }
   .title{
       height:170px;
       width:100%;
       position:relative;
       
       font-family:微软雅黑;
       font-size:37px;
       font-weight:bold;
   }
   .Form{
       float:left;
       position: relative;
       font-size:20px;
       font-weight:bold;
       color:azure;
       left:70%;
       top:8%;  
   }
</style>
