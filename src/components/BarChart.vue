<template>
    <h2>
        <a href="https://d3js.org" target="_blank"><center>大学生睡眠质量状况@Vue3</center></a>
        <div id="name" style="text-align:right">
                    <b>20数科张劲涛</b>
                </div>
    </h2>
    <div id="bar-chart-container"></div>
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

var color=d3.schemeCategory10;
export default defineComponent({
    mounted(){
        this.drawBarChart(data);
    },
    methods:{
        drawBarChart(data){
            var width=window.screen.width;
            var h=window.screen.height;
            var w=800;
            h=h*0.75;
            var svg=d3.select("body")
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
        }

    }
})

</Script>