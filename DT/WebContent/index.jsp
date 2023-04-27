<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>DT</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script>
function search() {
	// to search by using title name in search box
  var query = document.getElementById("search").value;
  var cards = document.getElementsByClassName("card");

  for (var i = 0; i < cards.length; i++) {
    var title = cards[i].querySelector("h2").innerText;//used h2 for title 
    if (title.toLowerCase().includes(query.toLowerCase())) {
      cards[i].style.display = "";
    } else {
      cards[i].style.display = "none";
    }
  }
}
//to go to specific url
function navigateToPage(pageIndex) {
    window.location.href = "/index.jsp?page=" + pageIndex;
}

</script>
	
</head>	
<body>

<%@include  file="DT/DTNav.html" %>
<%@ page import="java.sql.*" %>

<% try{
	 int startIndex = 0;
	int pageSize = 10; 
	Class.forName("com.mysql.cj.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306?user=root&password=admin";
Connection conn = DriverManager.getConnection(url);
System.out.println("Connnection established");

String pageParam = request.getParameter("page");
System.out.println(pageParam);
int pageIndex = pageParam == null ? 1 : Integer.parseInt(pageParam);
startIndex = (pageIndex - 1) * pageSize; 
String sql = "SELECT * FROM test.product LIMIT ?, ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, startIndex);
stmt.setInt(2, pageSize);
ResultSet rs = stmt.executeQuery();

System.out.println("executed");

%>
<div>
<input type="text" name="search" id="search" placeholder="Search Project Name" onkeyup=search()>
</div>


<%

//loop to show only 10 cards at a page
 for (int i = startIndex; i < startIndex + pageSize && rs.next(); i++) { 
		
    String image=rs.getString(1);
	String Title= rs.getString(2);
	String desc= rs.getString(3);
	String outcomeheader=rs.getString(4);
	String outcomedesc= rs.getString(5);
	String prereq= rs.getString(6);
	String author= rs.getString(7);
	
	%>
	
	<div class="card">
	<div class="col-1">
	<img src="<%=image %>"  alt="Image">
	</div>
	<div class="col-2">
	<h2><%=Title %></h2>	
	<p><%=desc %></p>
	<h3><%=outcomeheader %></h3>
	<p><%=outcomedesc %></p>
	<h5>Pre-requisites</h5>
	<p><%=prereq %></p>
	</div>
	<div class="col-3">
		<h4>Selection by</h4>
		<div id="sub-1">
		<img alt="" src="<%=image%>">
		<div id="sub-2">
		<h5><%=author %></h5>
		<h6>Deep thought</h6>
		</div>
		</div>
		</div>
		
		<button>Explore</button>
		
		
	</div>
	
	</div>

	  
	<% }%>
	
	<%
	// row count to check the next page in the card
	String countSql = "SELECT COUNT(*) FROM test.product";
PreparedStatement countStmt = conn.prepareStatement(countSql);
ResultSet countRs = countStmt.executeQuery();
countRs.next();
int rowCount = countRs.getInt(1);
	%>
	
<div id="pageNavigation">
<% if(pageIndex>1){ %>
	<a href="index.jsp?page=<%= pageIndex - 1 %>"><</a>
	<%} %>
	<h2><%= pageIndex %></h2>
	<%System.out.println(pageIndex) ;%>
	<%  if((startIndex + pageSize) < rowCount) { %>
    <a href="index.jsp?page=<%= pageIndex + 1 %>" >></a>
	<%} %>
</div>

		
	<%
}catch (Exception e) {
		e.printStackTrace();
	} %>
	

</body>
</html>