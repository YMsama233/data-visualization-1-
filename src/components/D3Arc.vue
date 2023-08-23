<template>
    <h2>
        <a href="https://d3js.org" target="_blank"><center>大学生睡眠质量状况@Vue3</center></a>
        <div id="name" style="text-align:right">
                    <b>20数科张劲涛</b>
                </div>
    </h2>
    <div id="pie-container"></div>
</template>

<script>
import { defineComponent} from 'vue';
import * as d3 from "d3";

var data=new Array(5);
data['非常差']=1.63;
data['比较差']=8.02;
data['一般']=36.55;
data['比较好']=39.02;
data['非常好']=14.78;
var dataset=[["非常差",1.63],["比较差",8.02],["一般",36.55],["比较好",39.02],["非常好",14.78]];



// var data=[{startAngle:0,endAngle:0.0163*2*Math.PI},
// {startAngle:0.0163*2*Math.PI,endAngle:2*Math.PI*0.0965},
// {startAngle:2*Math.PI*0.0965,endAngle:2*Math.PI*0.462},
// {startAngle:2*Math.PI*0.462,endAngle:2*Math.PI*0.8522},
// {startAngle:2*Math.PI*0.8522,endAngle:2*Math.PI}]

var color=d3.schemeCategory10;

export default defineComponent({
    mounted(){
        this.drawPie(dataset,data);
    },
    methods:{
        drawPie(dataset,data){
            var width=window.screen.width;
            var h=window.screen.height;
            var w=800;
            h=h*0.75;
            var svg=d3.select("#pie-container")
                    .append("svg")
                    .attr("width",width)
                    .attr("height",h);
            svg.selectAll("rect")
                .data(Object.values(data))
                .enter()
                .append("rect")
                .attr("x",function(d,i){return (w/5)*i+(width-w)/2})
                .attr("y",d=>(h-d/50*h-100))
                .attr("width",w*0.9/7)
                .attr("height",function(d){return d/50*h})
                .attr("fill",(d,i)=>color[i]);
            svg.selectAll("text1")
                .data(Object.values(data))
                .enter()
                .append("text")
                .attr("x",function(d,i){return (w/5)*i+(width-w)/2})
                .attr("y",d=>(h-d/50*h-120))
                .attr("dx",w*0.9/14-30)
                .attr("fill","black")
                .text(function(d){return d+"%"});
            svg.selectAll("text2")
                .data(Object.keys(data))
                .enter()
                .append("text")
                .attr("x",function(d,i){return (w/5)*i+(width-w)/2})
                .attr("y",h-80)
                .attr("dx",w*0.9/14-20)
                .attr("fill","black")
                .text(function(d,i){return Object.keys(data)[i]});
                
            var pie=d3.pie()
                    .value(function(d){return d[1]});
            var piedata=pie(dataset)
            console.log(piedata);

            var arc1=d3.arc()
                        .innerRadius(70)
                        .outerRadius(150); 

            var arc1_=d3.arc()
                        .innerRadius(70)
                        .outerRadius(190); 
            
            svg.selectAll("path")
                .data(piedata)
                .enter()
                .append("path")
                .attr("d",function(d) {
                    console.log(arc1(d))
                    return arc1(d)}) 
                .attr("fill",function(d,i){
                    console.log(piedata[i]);
                    return color[i]
                })

                .attr("stroke","blue")
                .attr("transform","translate("+w/4+","+h/3+")")
                .on("mouseover",function(){
                    
                    d3.select(this)
                        .attr("d",function(d) {
                            return arc1_(d)}) 
                        .attr("fill",function(d){
                            for(var i=0;i<5;i++){
                                if(d==piedata[i]){
                                    return color[i+5]}
                                }
                        });
                })
                .on("mouseout",function(){
                    d3.select(this)
                        .attr("d",function(d) {
                            return arc1(d)}) 
                            .attr("fill",function(d){
                            for(var i=0;i<5;i++){
                                if(d==piedata[i]){
                                    return color[i]}
                                }
                        });
                });
            svg.selectAll("text3")
                .data(piedata)
                .enter()
                .append("text")
                .attr("text-anchor","middle")
                .attr("transform",function(d){
                    var x=arc1.centroid(d)[0];
                    var y=arc1.centroid(d)[1];
                    return "translate("+(w/4+x)+","+(h/3+y)+")"
                })
                .attr("fill","black")
                .text(function(d){return d.value+"%"});
        } 
    }
})

</Script>