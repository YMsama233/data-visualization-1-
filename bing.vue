<template>
  <h1 style="color:rgb(0, 235, 166) ;">豆瓣2020年以来电影评分层次结构</h1>
  <form name="myForm" action="" method="" style="position:absolute;top:15%;left:10%;line-height:20.5px;">
    <input type="radio" class="radioclass1" name="single1" checked="true">圆形节点对齐
    <input type="radio" class="radioclass1" name="single1">圆形层次对齐
    <input type="radio" class="radioclass1" name="single1">横向节点对齐
    <input type="radio" class="radioclass1" name="single1">横向层次对齐
    <input type="radio" class="radioclass1" name="single1">纵向节点对齐
    <input type="radio" class="radioclass1" name="single1">纵向层次对齐
  </form>
  <span style="position:absolute;top:18%;left:11%">0%</span>
  <input type="range" min="0" max="100" step="1" value="100" id="limit"
    style="width:460px;position:absolute;top:18%;left:12%;" />
  <span style="position:absolute;top:18%;left:770px">100%</span>
</template>

<script>
import { defineComponent } from 'vue';
import * as d3 from "d3";
import axios from "axios";

export default defineComponent({
  mounted() {
    axios.get("./data.json").then((res) => {
      this.drawGraphChart(res.data);
    });
  },
  methods: {
    drawGraphChart(graph) {
      const width = (window.innerWidth ||
        document.documentElement.clientWidth ||
        document.body.clientWidth) * 0.98;
      const height = (window.innerHeight ||
        document.documentElement.clientHeight ||
        document.body.clientHeight) * 0.98;
      var color = d3.schemeCategory10;

      var svg = d3.select("#app")
        .append("svg")
        .attr("width", width)
        .attr("height", height*30/19)

      var radius = width / 2

      var jianjie = d3.selectAll("#app")
        .append("div")
        .attr("class", "jianjie")
        .append("text")
        .attr("x", width *8/11)
        .attr("y", height/40)
        .attr("font-size", height/40)
        .style("fill", "rgb(255, 0, 76)");
      jianjie.html("豆瓣电影提供最新的电影介绍及评论包括上映影片的影讯查询及购票服务。你可以记录想看、在看和看过的电影电视剧,顺便打分、写影评。根据你的口味,豆瓣电影会推荐好电影给你。")
        .style("opacity", 1.0);

      var svg0 = jianjie.append("svg")
        .attr("width", height/2)
        .attr("height", height*20/35)
      svg0.append("a")
        .attr("xlink:href","https://movie.douban.com/")
        .attr("xlink:title","豆瓣官网")
        .attr("target","_blank")
        .append("text")
        .attr("x", height*19/40)
        .attr("y", height*6/40)
        .attr("text-anchor", "end")
        .attr("font-size", height/40)
        .style("fill", "rgb(0, 176, 220)")
        .on("mouseover",function(d){
          d3.select(this).style("fill", "rgb(0, 0, 150)")
        })
        .on("mouseout",function(d){
          d3.select(this).style("fill", "rgb(0, 220, 176)")
        })
        .text("豆瓣电影");
      svg0.append("text")
        .attr("x", height*19/40)
        .attr("y", height*7/40)
        .attr("text-anchor", "end")
        .attr("font-size", height/40)
        .style("fill", "rgb(255, 0, 76)")
        .text("20数科王熠鹏");
      d3.selectAll(".radioclass1")
        .on("click", function () {
          for (var i = 0; i < myForm.single1.length; i++) {
            if (myForm.single1[0].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.cluster().size([2 * Math.PI * this.value / 100, radius * 3 / 10]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" + radius + "," + (height/ 2) + ")");
                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", d3.linkRadial()
                    .angle(d => d.x)
                    .radius(d => d.y))
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'rotate(' + (d.x * 180 / Math.PI - 90) + ')' + ' translate(' + d.y + ',0)')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d =>
                    'rotate(' + (d.x * 180 / Math.PI - 90) + ')' + ' translate(' + d.y + ',0)'
                    + ' rotate(' + (d.x >= Math.PI ? 180 : 0) + ')')
                  .attr("font-size","10px")
                  .attr("x", d => d.x < Math.PI === !d.children ? 6 : -6)
                  .attr("text-anchor", d => d.x < Math.PI === !d.children ? "start" : "end")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              });
            }
            else if (myForm.single1[1].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.tree().size([2 * Math.PI * this.value / 100, radius * 3 / 10]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" + radius + "," + (height /2) + ")");
                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", d3.linkRadial()
                    .angle(d => d.x)
                    .radius(d => d.y))
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'rotate(' + (d.x * 180 / Math.PI - 90) + ')' + ' translate(' + d.y + ',0)')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d =>
                    'rotate(' + (d.x * 180 / Math.PI - 90) + ')' + ' translate(' + d.y + ',0)'
                    + ' rotate(' + (d.x >= Math.PI ? 180 : 0) + ')')
                  .attr("font-size","10px")
                  .attr("x", d => d.x < Math.PI === !d.children ? 6 : -6)
                  .attr("text-anchor", d => d.x < Math.PI === !d.children ? "start" : "end")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              })
            }
            else if (myForm.single1[2].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.cluster().size([height * 3 / 2, (width * 17 / 20) * this.value / 100]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" + width / 20 + "," + height / 20 + ")");

                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", function (d) {
                    return 'M' + d.source.y + ',' + d.source.x +
                      'C' + (d.source.y + d.target.y) / 2 + ',' + d.source.x +
                      ' ' + (d.source.y + d.target.y) / 2 + ',' + d.target.x +
                      ' ' + d.target.y + ',' + d.target.x
                  })
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'translate(' + d.y + ',' + d.x + ')')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d => 'translate(' + d.y + ',' + (d.x) + ')')
                  .attr("font-size",function(d){
                    if (d.height % 4==0)
                      return "10px"
                    if (d.height % 4==1)
                      return "15px"
                    if (d.height % 4==2)
                      return "17px"
                    else  return "20px"
                  }
                  )
                  .attr("x", 6)
                  .attr("text-anchor", "start")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              })
            }
            else if (myForm.single1[3].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.tree().size([height * 3 / 2, (width * 17 / 20) * this.value / 100]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" + width / 20 + "," + height / 20 + ") ");

                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", function (d) {
                    return 'M' + d.source.y + ',' + d.source.x +
                      'C' + (d.source.y + d.target.y) / 2 + ',' + d.source.x +
                      ' ' + (d.source.y + d.target.y) / 2 + ',' + d.target.x +
                      ' ' + d.target.y + ',' + d.target.x
                  })
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'translate(' + d.y + ',' + d.x + ')')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d => 'translate(' + d.y + ',' + (d.x) + ')')
                  .attr("font-size", function(d){
                    if (d.height % 4==0)
                      return "10px"
                    if (d.height % 4==1)
                      return "15px"
                    if (d.height % 4==2)
                      return "17px"
                    else  return "20px"
                  }
                  )
                  .attr("x", 6)
                  .attr("text-anchor", "start")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              })
            }
            else if (myForm.single1[4].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.cluster().size([(width * 17 / 20), (height*4/3) * this.value / 100]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" +(width * 37 / 40) + "," + 20  + ")  rotate(90)");

                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", function (d) {
                    return 'M' + d.source.y + ',' + d.source.x +
                      'C' + (d.source.y + d.target.y) / 2 + ',' + d.source.x +
                      ' ' + (d.source.y + d.target.y) / 2 + ',' + d.target.x +
                      ' ' + d.target.y + ',' + d.target.x
                  })
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'translate(' + d.y + ',' + d.x + ')')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d => 'translate(' + d.y + ',' + (d.x) + ')')
                  .attr("font-size",function(d){
                    if (d.height % 4==0)
                      return "10px"
                    if (d.height % 4==1)
                      return "15px"
                    if (d.height % 4==2)
                      return "17px"
                    else  return "20px"
                  }
                  )
                  .attr("x", 6)
                  .attr("text-anchor", "start")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              })
            }
            else if (myForm.single1[5].checked == true) {
              d3.select("#limit").on("mousemove", function (d, i) {
                svg.selectAll('*').remove();
                var tree = d3.tree().size([(width * 17 / 20), (height*4/3) * this.value / 100]);
                var root = tree(d3.hierarchy(graph));
                var links = root.links();
                var nodes = root.descendants()
                var gc = svg.append("g")
                  .attr("transform", "translate(" + (width * 37 / 40) + "," + 20 + ") rotate(90)");

                var lines = gc.selectAll("path")
                  .data(links)
                  .join("path")
                  .attr("fill", "none")
                  .attr("stroke", "rgb(255, 0, 76)")
                  .attr("stroke-width", "1")
                  .attr("d", function (d) {
                    return 'M' + d.source.y + ',' + d.source.x +
                      'C' + (d.source.y + d.target.y) / 2 + ',' + d.source.x +
                      ' ' + (d.source.y + d.target.y) / 2 + ',' + d.target.x +
                      ' ' + d.target.y + ',' + d.target.x
                  })
                var circles = gc.selectAll("circle")
                  .data(nodes)
                  .join("circle")
                  .attr("r", d => d.height * 2 + 2)
                  .style("fill", d => color[d.height % 10])
                  .attr("transform", d => 'translate(' + d.y + ',' + d.x + ')')
                var texts = gc.selectAll("text")
                  .data(root.descendants())
                  .join("text")
                  .attr("transform", d => 'translate(' + d.y + ',' + (d.x) + ')')
                  .attr("font-size", function(d){
                    if (d.height % 4==0)
                      return "10px"
                    if (d.height % 4==1)
                      return "15px"
                    if (d.height % 4==2)
                      return "17px"
                    else  return "20px"
                  }
                  )
                  .attr("x", 6)
                  .attr("text-anchor", "start")
                  .text(d => d.data.name)
                  .clone(1).lower()
                  .attr("fill", d => color[d.depth]);
              })
            }
          }
        });


    }
  }
})
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
#app {
  max-width: 100%;
  margin: 0rem;
  padding: 0rem;
  text-align: center;
  background-image:
    linear-gradient(to bottom, rgba(255, 255, 255, 0.5), rgba(255, 255, 255, 0.5)),
    url("public/image/jb.jpg");
  background-size: 102% auto;
  background-attachment: fixed;
}
.jianjie {
  position: absolute;
  width: 26%;
  height: auto;
  font-size: 25px;
  text-align: left;
  color: rgb(100, 100, 176);
  border-radius: 15px;
  left:72%;
  top:1%;
}
.a{
  position: absolute; 
  left: 0px; 
  top: 0px;
}
</style>
