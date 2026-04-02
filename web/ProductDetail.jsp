<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, model.DBConnect, java.math.BigDecimal, java.text.DecimalFormat" %>

<%
    String id = request.getParameter("id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Detail | GachaStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @font-face { font-family: 'Aptos SemiBold'; src: local('Aptos SemiBold'), local('Aptos-SemiBold'); }
        :root { --shop-blue: #3498db; --dark-text: #2c3e50; --price-red: #e74c3c; }
        body { font-family: 'Aptos SemiBold', 'Segoe UI', sans-serif; background: #f4f6f9; margin: 0; color: var(--dark-text); }
        .container { width: 85%; max-width: 1200px; margin: 50px auto; background: white; padding: 50px; border-radius: 20px; display: flex; gap: 60px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        .image-box { flex: 1; }
        .product-img { width: 100%; height: 500px; object-fit: contain; border-radius: 15px; transition: 0.4s ease; }
        .info { flex: 1; display: flex; flex-direction: column; }
        h2 { font-size: 42px; margin: 0 0 15px 0; }
        .price { color: var(--price-red); font-size: 38px; font-weight: bold; margin-bottom: 25px; }
        .meta { color: #7f8c8d; margin-bottom: 12px; font-size: 18px; }
        .desc { margin-top: 30px; line-height: 1.8; color: #444; font-size: 20px; border-top: 1px solid #eee; padding-top: 20px; }
        .purchase-controls { margin-top: 35px; display: flex; flex-direction: column; gap: 20px; }
        .qty-group { display: flex; align-items: center; gap: 15px; }
        .qty-input { width: 80px; padding: 10px; font-size: 18px; border: 2px solid #ddd; border-radius: 8px; text-align: center; }
        .actions { display: flex; gap: 15px; }
        .btn { padding: 18px 30px; border: none; cursor: pointer; border-radius: 12px; font-size: 18px; font-weight: bold; transition: 0.3s; text-decoration: none; text-align: center; }
        .btn-buy { background: var(--dark-text); color: white; flex: 2; }
        .btn-buy:hover { background: var(--shop-blue); transform: translateY(-3px); }
        .btn-back { background: #ecf0f1; color: #7f8c8d; flex: 1; }
    </style>
</head>
<body>

<%
try {
    conn = DBConnect.getConnection();
    ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, Integer.parseInt(id));
    rs = ps.executeQuery();

    if(rs.next()) {
        BigDecimal priceBD = rs.getBigDecimal("price");
        DecimalFormat df = new DecimalFormat("#,##0.###");
        String formattedPrice = df.format(priceBD != null ? priceBD : BigDecimal.ZERO);
%>

<div class="container">
    <div class="image-box">
        <img class="product-img" src="<%= request.getContextPath() %>/images/<%= rs.getString("image") %>" onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">
    </div>

    <div class="info">
        <h2><%= rs.getString("name") %></h2>
        <div class="price"><%= formattedPrice %> <span style="font-size: 20px;">VND</span></div>
        <div class="meta"><i class="fa-solid fa-layer-group"></i> <b>Stock:</b> <%= rs.getInt("quantity") %> units</div>
        <div class="meta"><i class="fa-solid fa-calendar-days"></i> <b>Release:</b> <%= rs.getDate("date") %></div>
        <div class="desc"><b>Product Description:</b><br><%= rs.getString("description") %></div>

        <form action="cartservlet" method="POST" class="purchase-controls">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%= id %>">
            
            <div class="qty-group">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" class="qty-input" value="1" min="1" max="<%= rs.getInt("quantity") %>">
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-buy">
                    <i class="fa-solid fa-cart-plus"></i> Add to Shopping Tray
                </button>
                <a href="home.jsp" class="btn btn-back">Return</a>
            </div>
        </form>
    </div>
</div>

<%
    } else {
        out.println("<h3 style='text-align:center; margin-top:50px;'>Product not found</h3>");
    }
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e){}
    if(ps != null) try { ps.close(); } catch(Exception e){}
    if(conn != null) try { conn.close(); } catch(Exception e){}
}
%>
</body>
</html>