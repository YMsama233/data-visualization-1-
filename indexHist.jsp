<!DOCTYPE html>
<body>
<div id="wc"></div>
<%@ page contentType="text/html; charset=gb2312" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.cj.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
                        out.print("<center><h1><font color=blue>Matrix Word Cloud English Learning</h1></center>"); 

						String driverName="com.mysql.cj.jdbc.Driver"; 

						String userName="root"; 

						String userPasswd="200202139"; 

						String dbName="dict"; 

						String tableName="map_enword"; 

						String url="jdbc:mysql://localhost/"+dbName+"?user="+userName+"&password="+userPasswd; 
						Class.forName("com.mysql.cj.jdbc.Driver").newInstance(); 
						Connection connection=DriverManager.getConnection(url); 
						Statement statement = connection.createStatement(); 
					    int[] count=new int[26];
						for(int i=0;i<26;i++){
							int aa=Integer.valueOf('a')+i;
							char cha = (char) aa;
							//out.print(aa);
							out.print(cha);

							//String sql="SELECT * FROM "+tableName+" where english like 'a%' "+"order by english"; 
							//String sql="SELECT * FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
                            String sql="SELECT count(*) FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
							ResultSet rs = statement.executeQuery(sql);  

							while(rs.next()) { 
								count[i]=rs.getInt(1);
                                out.print(count[i]+" "); 
							}
							out.print(" "+count[i]+" <br>"); 
							rs.close();
						}
						
						 
						statement.close(); 
						connection.close(); 
%>
<script src="d3.v3.js"></script>
		<script>
		    var w=window.innerWidth
|| document.documentElement.clientWidth
|| document.body.clientWidth;

			var h=window.innerHeight
|| document.documentElement.clientHeight
|| document.body.clientHeight;
			w=w*0.98;
			h=h*0.95;
			var color=d3.scale.category10();

			
			//var dataset=[100,90,88,700,888,180];
			var dataset=new Array(10);
			for (var i=0;i<10;i++){
				dataset[i]=Math.floor(Math.random()*500);
			}
            var dataset=new Array(26);
            <% for (int i=0;i<26;i++){%>
               dataset[<%=i%>]=<%=count[i]%>
            
            <%}%>
			var ww=w/dataset.length;
			var svg=d3.select("body")
			          .append("svg")
					  .attr("width",w)
					  .attr("height",h);
			var rect=svg.selectAll("rect")
			            .data(dataset)
				        .enter()
			            .append("rect")
                          .attr("x",function(d,i){return i*w/dataset.length})
						  .attr("y",function(d){return h-d})
						  .attr("width",ww*0.95)
						  .attr("height",function(d){return d})
						  .attr("fill",function(d,i){return color(i)});
						  
			var rect=svg.selectAll("text")
			            .data(dataset)
				        .enter()
			            .append("text")
                          .attr("x",function(d,i){return i*w/dataset.length})
						  .attr("y",function(d){return h-d})
                          .text(function(d){return d})
						  .attr("dx",ww/2)
						  .attr("dy","-1em")
						  .attr("text-anchor","middle")
                          .attr("fill",function(d,i){return color(i)});					  
		
		</script>

</body>