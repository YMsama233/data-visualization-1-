<!DOCTYPE html>
<body bgcolor="#CFC3A9">

<div id="wc"  style="background:#FFFFFF" align="center" >
<div style="white-space:'nowrap'"><img src="eng.jpg" width=200></div>
<div style="font-family:黑体;font-size:600%;color:#686789;white-space:'nowrap'">英语可视化</div>
</div>
<%@ page contentType="text/html; charset=gb2312" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
                        out.print("<center><font color='#686789'>English WordCloud</font></center>"); 
						//驱动程序名 
						String driverName="com.mysql.jdbc.Driver"; 
						//数据库用户名 
						String userName="root"; 
						//密码 
						String userPasswd="123456"; 
						//数据库名 
						String dbName="english2022"; 
						//表名 
						String tableName="map_enword"; 
						//联结字符串 
						String url="jdbc:mysql://localhost/"+dbName+"?user="+userName+"&password="+userPasswd; 
						Class.forName("com.mysql.jdbc.Driver").newInstance(); 
						Connection connection=DriverManager.getConnection(url); 
						Statement statement = connection.createStatement(); 
					    int[] count=new int[26];
						for(int i=0;i<26;i++){
							int aa=Integer.valueOf('a')+i;
							char cha = (char) aa;
							//out.print(aa);
							//out.print(cha);

							//String sql="SELECT * FROM "+tableName+" where english like 'a%' "+"order by english"; 
							//String sql="SELECT * FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
                            String sql="SELECT count(*) FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
							ResultSet rs = statement.executeQuery(sql);  
							// 输出每一个数据值 
							while(rs.next()) { 
								count[i]=rs.getInt(1);
                                //out.print(count[i]+"|"); 
							}
							//out.print(" "+count[i]+"|"); 
							rs.close();
						}
						
						 
						statement.close(); 
						connection.close(); 
%>
<script src="../d3.v3.min.js"></script>
<script src="../d3.layout.cloud.js"></script>
		<script>
		    var w=window.innerWidth
|| document.documentElement.clientWidth
|| document.body.clientWidth;

			var h=window.innerHeight
|| document.documentElement.clientHeight
|| document.body.clientHeight;
			w=w*0.98;
			h=h*0.95;
			var color=d3.scale.category20();

			
			//var dataset=[100,90,88,700,888,180];
			var dataset=new Array(10);
			for (var i=0;i<10;i++){
				dataset[i]=Math.floor(Math.random()*500);
			}
            var dataset=new Array(26);
            <% for (int i=0;i<26;i++){%>
               dataset[<%=i%>]=<%=count[i]%>            
            <%}%>
			var fill = d3.scale.category20();		
		 //var words=[{text:"战狼2",size:57},{text:"速度与激情8",size:27},{text:"羞羞的铁拳",size:22},{text:"功夫瑜伽",size:18},
		 //{text:"西游伏妖篇",size:17},{text:"变形金刚5",size:16},{text:"摔跤吧！爸爸",size:13},{text:"芳华",size:13},
		 //{text:"寻梦环游记",size:12},{text:"加勒比海盗5",size:12}];
            var words=new Array(26);
            <% for (int i=0;i<26;i++){%>
               words[<%=i%>]={text:String.fromCharCode(<%=65+i%>),size:<%=count[i]%>}            
            <%}%>
		 var wc=d3.layout.cloud()
				  .size([w, 200])
				  .words(words)
				  .padding(0)
				  .rotate(function() { return ~~(Math.random() * 1) * 90; })
				  .font("Impact")
				  .fontSize(function(d) { return Math.sqrt(d.size)+30; })
				  .on("end", draw)
				  .start();

		  function draw(words) {
			d3.select("body").append("svg")
				.attr("width", w)
				.attr("height", 200)
			  .append("g")
				.attr("transform", "translate("+w/2+",100)")
			  .selectAll("text")
				.data(words)
			  .enter()
              .append("a")
                .attr("xlint:href",function(d){ return "word.jsp?w="+d.text})
              .append("text")
				.style("font-size", function(d) { return Math.sqrt(d.size)+30 + "px"; })
				.style("font-family", "Impact")
				.style("fill", function(d, i) { return fill(i); })
				.attr("text-anchor", "middle")
				.attr("transform", function(d) {
				  return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
				})
				.text(function(d) { return d.text; });
		  }
		</script>
<div id="wc"  style="background:#9AA690" align="right" >
<div style="white-space:'nowrap'"><img src="eng.jpg" width=40></div>
<div style="font-family:黑体;font-size:100%;color:#686789;white-space:'nowrap'">◇◆◇如艺可视化@中传◇◆◇</div>
</div>
</body>