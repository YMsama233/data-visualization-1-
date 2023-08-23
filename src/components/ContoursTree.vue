<template> 
    
      <div id="container" style="width:100px;height:100%;float:left">
      </div>
  
  
  </template>
  
  
  
  <script>
  import { defineComponent } from 'vue';
  import axios from "axios";
  import * as d3 from "d3";
  
  
  
  export default defineComponent({
      mounted() {      
      axios.get("./guizhou.json").then((res) => {
                  this.drawGraphChart(res.data);
              });        
      },
      methods:{
        drawGraphChart(data){
            var  width=(window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth)*0.98;
			var  height=(window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight)*0.98;
		
			var svg = d3.select("body").append("svg")
						.attr("width", width)
						.attr("height", height);
                                                          
			var projection = d3.geoMercator()
								.center([106.6992,26.7682])
                                .scale(7700)
								.translate([width/2, height/2]);
		
			//定义地形路径生成器
			var geoPath = d3.geoPath().projection(projection);	//设定投影
                         

			//颜色比例尺
			var color = d3.schemePaired;           //d3.schemeBlues[9];       //d3.schemeCategory10;
            console.log(color)

    
            console.log(data);
            var scaleColor = d3.scaleOrdinal()
                    .domain(d3.range(data.features.length))
                    .range(d3.schemeCategory10);

            var groups = svg.append("g");
                
            groups.selectAll("path")
                    .data(data.features)
                    .enter()
                    .append("path")
                    .attr("class","province")
                    .attr("stroke","black")
                    .attr("fill",(d,i)=>scaleColor(i%12))
                    .attr("d",d=>geoPath(d));	//使用路径生成器			  
            
                svg.selectAll(".texts")															
                            .data(data.features)								
                            .enter()
                            .append("text")
                            .attr("class", "texts")	
                            .text(function(d){return d.properties.name})
                            .attr("transform", function(d) {
                                var centroid = geoPath.centroid(d),
                                    x = centroid[0],
                                    y = centroid[1];
                                return "translate(" + (x-10) + ", " + y + ")";
                            })
                            .attr('fill','999')
                            .attr("font-size","16px");	        
        }
    }
  })
  </script>
  