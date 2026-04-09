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
    --price-red: #e74c3c;
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

/* COMBINED PRODUCT CARD STYLE */
.product {
    position: relative; /* For Sold Out Badge */
    background: white;
    padding: 18px;
    border-radius: 12px;
    text-align: center;
    transition: all 0.3s ease;
    border: 2px solid #eee;
    display: flex;
    flex-direction: column;
}

.product:hover {
    transform: translateY(-12px);
    border: 2px solid var(--shop-blue);
    box-shadow: 0 15px 25px rgba(0,0,0,0.2);
}

.product img {
    width: 100%;
    height: 280px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 15px;
}

.out-of-stock-img {
    filter: grayscale(100%) opacity(0.5);
}

.sold-out-badge {
    position: absolute;
    top: 15px;
    right: 15px;
    background: rgba(231, 76, 60, 0.9);
    color: white;
    padding: 6px 12px;
    border-radius: 4px;
    font-weight: bold;
    z-index: 10;
}

.product h3 {
    margin: 10px 0;
    font-size: 20px;
    color: var(--dark-nav);
}

.price {
    color: var(--price-red);
    font-size: 22px;
    font-weight: bold;
    margin-bottom: 5px;
}

.stock-text {
    color: #777;
    font-size: 14px;
    margin-bottom: 15px;
}

.btn-view {
    background: var(--shop-blue);
    color: white;
    border: none;
    padding: 12px;
    width: 100%;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
    transition: 0.2s;
    text-decoration: none;
}

.btn-view:hover {
    background: #2980b9;
}

.admin-btn {
    background: #8e44ad;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    margin: 5px;
    cursor: pointer;
}
</style>
</head>

<body>
   
<div class="topnav">
    <a href="home.jsp">Home</a>
    <a href="Cart.jsp">My Cart</a>
    <a href="about.jsp">About Us</a>
</div>

<div style="text-align:center; margin-top:20px;">
<% if(role == null || "guest".equals(role)) { %>
    <button onclick="window.location.href='login.jsp'" class="btn-view" style="width: auto; padding: 10px 20px;">Login</button>
    <button onclick="window.location.href='register.jsp'" class="btn-view" style="width: auto; padding: 10px 20px;">Register</button>
<% } else { %>
    <span style="color: white; margin-right: 15px; background: rgba(0,0,0,0.5); padding: 5px 15px; border-radius: 20px;">Welcome, <%= user %>!</span>
    <button onclick="window.location.href='login.jsp'" class="btn-view" style="width: auto; padding: 10px 20px; background: #e74c3c;">Log Out</button>
<% } %>
</div>

<% if("admin".equals(role)){ %>
<div style="text-align:center; margin-top:10px;">
    <button onclick="window.location.href='ProductList.jsp'" class="admin-btn">Manage Inventory</button>
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
        int qty = rs.getInt("quantity");
        boolean isSoldOut = (qty <= 0);
        BigDecimal pPrice = rs.getBigDecimal("price");
        if(pPrice == null) pPrice = BigDecimal.ZERO;
        String formattedPrice = df.format(pPrice);
%>

<div class="product">
    <% if (isSoldOut) { %>
        <div class="sold-out-badge">SOLD OUT</div>
    <% } %>

    <img src="<%= request.getContextPath() %>/images/<%= rs.getString("image") %>" 
         class="<%= isSoldOut ? "out-of-stock-img" : "" %>"
         onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">

    <h3><%= rs.getString("name") %></h3>
    <span class="price"><%= formattedPrice %> VND</span>
    <p class="stock-text">
        <%= isSoldOut ? "<span style='color:red;'>Out of Stock</span>" : "Stock: " + qty %>
    </p>

    <button class="btn-view" 
            onclick="window.location.href='ProductDetail.jsp?id=<%= rs.getInt("id") %>'">
        <%= isSoldOut ? "View Details" : "Buy Now" %>
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