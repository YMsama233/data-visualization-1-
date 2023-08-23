<!DOCTYPE html>
<meta charset="utf-8">
<head>
	<style>
		.back{
			position:absolute;
            width: 100%;
            height: 100%;
            background: url("home.png");
            background-size: contain;
            z-index:-100;
		}
		.title{
			 
			position: relative;
			font-size: 80px;
			font-weight: bolder;
			text-align: center;
			color:#0f9b0f;
			top:30px;
		}
		.context{
			width: 100%;
			height:1000px;
			position: fixed;
			background-color: aliceblue;
			opacity: 0.6;
			z-index:-900;
		}
		.button1 {
			position: absolute;
			top:200px;
			left:30%;
			background-color: #ffffff;
			border:2px solid #008cba;
			border-radius:8px;
			font-size: 18px;
			color:  #87cefa;
			padding: 10px 20px;
			margin: 4px 2px;
			text-align: center;
			-webkit-transition-duration: 0.4s; /* Safari */
			transition-duration: 0.4s;
			text-decoration: none;
			overflow: hidden;
			cursor: pointer;
		}
		.button2 {
			position: absolute;
			top:200px;
			left:60%;
			background-color: #ffffff;
			border:2px solid #008cba;
			border-radius:8px;
			font-size: 18px;
			color:  #87cefa;
			padding: 10px 20px;
			margin: 4px 2px;
			text-align: center;
			-webkit-transition-duration: 0.4s; /* Safari */
			transition-duration: 0.4s;
			text-decoration: none;
			overflow: hidden;
			cursor: pointer;
		}
	</style>
</head>
<body>
<div class="back">
	<div class="context"></div>
	<div class="title">
		贵州省地域面积
	</div>
	<div class="main">
		<button class="button1">直方图显示</button>
		<button class="button2">词云图显示</button>
		<div id="container"></div>
	</div>
</div>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 

						String driverName="com.mysql.cj.jdbc.Driver"; 

						String userName="root"; 

						String userPasswd="200202139"; 

						String dbName="dict"; 

						String tableName="guizhou"; 

						String url="jdbc:mysql://localhost/"+dbName+"?user="+userName+"&password="+userPasswd; 
						Class.forName("com.mysql.cj.jdbc.Driver").newInstance(); 
						Connection connection=DriverManager.getConnection(url); 
						Statement statement = connection.createStatement(); 

						String[] name=new String[9];
						int[] sq=new int[9];
						
						for(int i=0;i<9;i++){
                            String sql="SELECT * FROM "+tableName+" where id = "+i+" "; 
							ResultSet rs = statement.executeQuery(sql);  

							while(rs.next()) { 
								sq[i]=rs.getInt("sq");
								name[i]=rs.getString("name");
							}
							rs.close();
						}
						

						
						
						 
						statement.close(); 
						connection.close(); 
%>
<script src="d3.v3.js"></script>
<script src="d3.layout.cloud.js"></script>
<script>
	var width=window.screen.width;
	var h=window.screen.height;
	w=1000;
	h=h*0.75;
    var fill = d3.scale.category20();
    var words=new Array(9);
	<% for (int i=0;i<9;i++){%>
		words[<%=i%>]={text:"<%=name[i]%>",size:<%=sq[i]%>};
	
	<%}%>

	var svg=d3.select("#container")
		.append("svg")
		.attr("width",width)
		.attr("height",h);
    var wc=d3.layout.cloud().size([w, h])
      .words(words)
      .padding(5)
      .rotate(function() { return ~~(Math.random() * 2) * 90; })
      .font("Impact")
      .fontSize(function(d) { return d.size/450; })
      .on("end", draw)
      .start();
    
    function draw(words) {
    svg.selectAll("text")
        .data(words)
        .enter().append("text")
        .style("font-size", function(d) { return d.size + "px"; })
        .style("font-family", "Impact")
        .style("fill", function(d, i) { return fill(i); })
        .attr("text-anchor", "middle")
        .attr("transform", function(d) {
            return "translate(" + [d.x+700, d.y+400] + ")rotate(" + d.rotate + ")";
        })
        .text(function(d) { return d.text; });
      }
</script>
    