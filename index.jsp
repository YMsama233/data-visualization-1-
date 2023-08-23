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
		.intro{
			position:fixed;
			top:35%;
			left:80%;
			font-size: larger;

		}
	</style>
</head>
<body>
<div class="back">
	<div class="context"></div>
	<div class="intro">单位：平方千米</div>
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
		<script>
			var width=window.screen.width;
            var h=window.screen.height;
            w=1000;
            h=h*0.75;
			var color=d3.scale.category10();
			var ww=w/9;
            var dataset=new Array(9);
            <% for (int i=0;i<9;i++){%>
               dataset["<%=name[i]%>"]=<%=sq[i]%>/100
            
            <%}%>


			var svg=d3.select("#container")
			          .append("svg")
					  .attr("width",width)
					  .attr("height",h);

			var rect=svg.selectAll("rect")
					  .data(Object.values(dataset))
					  .enter()
					  .append("rect")
						.attr("x",function(d,i){return (w/9)*i+(width-w)/2})
						.attr("y",function(d){return h-d-50})
						.attr("width",ww*0.95)
						.attr("height",function(d){return d})
						.attr("fill",function(d,i){return color(i)});
						
		  var rect=svg.selectAll("text")
					  .data(Object.values(dataset))
					  .enter()
					  .append("text")
						.attr("x",function(d,i){return (w/9)*i+(width-w)/2})
						.attr("y",function(d){return h-d-50})
						.text(function(d){return d*100})
						.attr("dx",ww/2)
						.attr("dy","-1em")
						.attr("text-anchor","middle")
						.attr("fill",function(d,i){return color(i)});	
						  
					svg.selectAll("text2")
						.data(Object.keys(dataset))
						.enter()
						.append("text")
						.attr("x",function(d,i){return (w/9)*i+(width-w)/2})
						.attr("y",h-20)
						.attr("dx",function(d){return 15})
						.attr("fill","black")
						.attr("font-size","20px")
						.text(function(d,i){return Object.keys(dataset)[i]});
		
		</script>
</body>