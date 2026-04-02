<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, model.DBConnect" %>
<%@ page import="java.math.BigDecimal, java.text.DecimalFormat" %>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if(role == null) role = "guest";
if(user == null) user = "Guest";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GachaStore | Official Arknights Merchandise</title>

<style>

@font-face {
    font-family: 'Aptos SemiBold';
    src: local('Aptos SemiBold'), local('Aptos-SemiBold');
}

:root {
    --shop-blue: #3498db;
    --dark-nav: #2c3e50;
}

body {
    background: url("https://i.redd.it/wehif1rowai41.jpg") no-repeat center center fixed;
    background-size: cover;

    font-family: 'Aptos SemiBold', 'Segoe UI', sans-serif;
    margin: 0;
}

.topnav {
    display: flex;
    align-items: center;
    background: var(--dark-nav);
    padding: 5px 40px;
}
.topnav a {
    color: white;
    padding: 15px 20px;
    text-decoration: none;
}

.main-container {
    width: 90%;
    max-width: 1200px;
    margin: 40px auto;
    background: rgba(255,255,255,0.96);
    padding: 30px;
    border-radius: 12px;
}

.product-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 35px;
    margin-top: 30px;
}

.product {
    background: white;
    padding: 18px;
    border-radius: 12px;
    text-align: center;
    transition: all 0.3s ease;
    border: 2px solid transparent;
}

.product:hover {
    transform: translateY(-12px) scale(1.03);
    border: 2px solid var(--shop-blue);
    box-shadow: 0 15px 25px rgba(0,0,0,0.2);
}

.product img {
    width: 100%;
    height: 280px;
    object-fit: cover;
    border-radius: 8px;
}

.product h3 {
    margin: 15px 0 10px;
    font-size: 22px;
}

.price {
    color: #e74c3c;
    font-size: 24px;
    font-weight: bold;
}

.product p {
    color: #777;
    font-size: 14px;
}

.btn-view {
    margin-top: 10px;
    background: var(--shop-blue);
    color: white;
    border: none;
    padding: 12px;
    width: 100%;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
    transition: 0.2s;
}

.btn-view:hover {
    background: #2980b9;
}
</style>
</head>

<body>
   
<div class="topnav">
    <a href="home.jsp">Home</a>
    <a href="#">Contact</a>
</div>

<div style="text-align:center; margin-top:20px;">
<% if(role == null || "guest".equals(role)) { %>
    <button onclick="window.location.href='login.jsp'" class="btn-view" style="width: auto; padding: 10px 20px;">Login</button>
    <button onclick="window.location.href='register.jsp'" class="btn-view" style="width: auto; padding: 10px 20px;">Register</button>
<% } else { %>
    <span style="color: white; margin-right: 15px;">Welcome, <%= user %>!</span>
    <button onclick="window.location.href='login.jsp'" class="btn-view" style="width: auto; padding: 10px 20px; background: #e74c3c;">Log Out</button>
<% } %>
</div>

<% if("admin".equals(role)){ %>
<div style="text-align:center; margin-top:10px;">
    <button onclick="window.location.href='ProductList.jsp'" class="admin-btn">Manage Inventory</button>
</div>
<div style="text-align:center; margin-top:10px;">
    <button onclick="window.location.href='AccountList.jsp'" class="admin-btn">Manage Accounts</button>
</div>
<% } %>

<div class="main-container">

<h2>Featured Products</h2>

<div class="product-grid">

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    conn = DBConnect.getConnection();
    ps = conn.prepareStatement("SELECT * FROM products");
    rs = ps.executeQuery();

    DecimalFormat df = new DecimalFormat("#,##0.###");

    while(rs.next()) {

        BigDecimal pPrice = rs.getBigDecimal("price");
        if(pPrice == null) pPrice = BigDecimal.ZERO;
        String formattedPrice = df.format(pPrice);
%>

<div class="product">

    <img src="<%= request.getContextPath() %>/images/<%= rs.getString("image") %>"
         onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">

    <h3><%= rs.getString("name") %></h3>

    <span class="price">
        <%= formattedPrice %> VND
    </span>

    <p>Stock: <%= rs.getInt("quantity") %></p>

    <button class="btn-view"
        onclick="window.location.href='ProductDetail.jsp?id=<%= rs.getInt("id") %>'">
        View Product
    </button>

</div>

<%
    }

} catch(Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e){}
    try { if(ps != null) ps.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}
%>

</div>

</div>

</body>
</html>