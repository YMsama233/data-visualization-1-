<!DOCTYPE html>
<body bgcolor="#CFC3A9">

<div id="wc"  style="background:#FFFFFF" align="center" >
<div style="white-space:'nowrap'"><img src="eng.jpg" width=200></div>
<div style="font-family:����;font-size:600%;color:#686789;white-space:'nowrap'">Ӣ����ӻ�</div>
</div>
<%@ page contentType="text/html; charset=gb2312" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
                        out.print("<center><font color='#686789'>English WordCloud</font></center>"); 
						//���������� 
						String driverName="com.mysql.jdbc.Driver"; 
						//���ݿ��û��� 
						String userName="root"; 
						//���� 
						String userPasswd="123456"; 
						//���ݿ��� 
						String dbName="english2022"; 
						//���� 
						String tableName="map_enword"; 
						//�����ַ��� 
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
							// ���ÿһ������ֵ 
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
		 //var words=[{text:"ս��2",size:57},{text:"�ٶ��뼤��8",size:27},{text:"���ߵ���ȭ",size:22},{text:"�����٤",size:18},
		 //{text:"���η���ƪ",size:17},{text:"���ν��5",size:16},{text:"ˤ�Ӱɣ��ְ�",size:13},{text:"����",size:13},
		 //{text:"Ѱ�λ��μ�",size:12},{text:"���ձȺ���5",size:12}];
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
<div style="font-family:����;font-size:100%;color:#686789;white-space:'nowrap'">��������տ��ӻ�@�д������</div>
</div>
</body>