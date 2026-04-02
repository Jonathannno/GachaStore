<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, model.DBConnect, java.math.BigDecimal, java.text.DecimalFormat" %>

<%
    // 1. Session Check
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    DecimalFormat df = new DecimalFormat("#,##0.###");
    BigDecimal grandTotal = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Your Cart | GachaStore</title>
    <style>
        body { font-family: 'Aptos SemiBold', sans-serif; background: #f4f7f6; padding: 40px; }
        
        .cart-card { background: white; max-width: 900px; margin: auto; padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        
        .item { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
        
        .qty-controls { display: flex; align-items: center; gap: 12px; }
        .btn-qty { 
            text-decoration: none; background: #eee; color: #333; 
            padding: 2px 10px; border-radius: 4px; font-weight: bold; transition: 0.2s;
        }
        .btn-qty:hover { background: #ddd; }
        
        /* Style for disabled plus button */
        .btn-disabled { background: #f9f9f9; color: #ccc; cursor: not-allowed; pointer-events: none; }

        .btn-delete { color: #e74c3c; text-decoration: none; font-size: 13px; margin-left: 15px; }
        .btn-delete:hover { text-decoration: underline; }

        .total { text-align: right; font-size: 24px; margin-top: 20px; color: #e74c3c; }
        .btn-checkout { background: #2c3e50; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; float: right; }
        .btn-checkout:hover { background: #34495e; }
    </style>
</head>
<body>

<div class="cart-card">
    <h2>Your Shopping Tray 🛒</h2>

    <%-- STOCK ERROR NOTIFICATION --%>
    <%
        String error = request.getParameter("error");
        String max = request.getParameter("max");
        if("exceed_stock".equals(error)) {
    %>
        <div style="background: #fdf2f2; color: #e74c3c; padding: 10px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f8d7da;">
            ⚠️ <b>Stock Limit Reached:</b> We only have <%= max %> units of that item available!
        </div>
    <% } %>

    <hr>

    <%
    try (Connection conn = DBConnect.getConnection()) {
        // CHANGE 1: Added p.quantity AS stock to the JOIN query
        String sql = "SELECT p.id as product_id, p.name, p.price, p.quantity as stock, c.quantity " +
                     "FROM cart c " +
                     "JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        boolean empty = true;
        while(rs.next()) {
            empty = false;
            int pId = rs.getInt("product_id");
            BigDecimal price = rs.getBigDecimal("price");
            int qty = rs.getInt("quantity");
            int stock = rs.getInt("stock"); // Fetch current stock
            BigDecimal subtotal = price.multiply(new BigDecimal(qty));
            grandTotal = grandTotal.add(subtotal);
    %>
        <div class="item">
            <div style="flex: 2;">
                <b><%= rs.getString("name") %></b><br>
                <small style="color: #666;">Stock available: <%= stock %></small>
            </div>

            <div class="qty-controls" style="flex: 1;">
                <%-- MINUS BUTTON --%>
                <a href="cartservlet?action=update&productId=<%= pId %>&quantity=<%= qty - 1 %>" class="btn-qty">-</a>
                
                <span><%= qty %></span>
                
                <%-- PLUS BUTTON: Disables itself if qty matches stock --%>
                <% if (qty < stock) { %>
                    <a href="cartservlet?action=update&productId=<%= pId %>&quantity=<%= qty + 1 %>" class="btn-qty">+</a>
                <% } else { %>
                    <span class="btn-qty btn-disabled">+</span>
                <% } %>
            </div>

            <div style="flex: 1; text-align: right;">
                <span><%= df.format(subtotal) %> VND</span>
                <a href="cartservlet?action=delete&productId=<%= pId %>" 
                   class="btn-delete" 
                   onclick="return confirm('Remove this item from cart?')">
                   Delete
                </a>
            </div>
        </div>
    <%
        }
        if(empty) {
            out.println("<p style='text-align:center; color:#777; margin: 30px 0;'>Your cart is currently empty.</p>");
        }
    } catch (Exception e) {
        out.println("Error displaying cart: " + e.getMessage());
    }
    %>

    <div class="total">
        Grand Total: <%= df.format(grandTotal) %> VND
    </div>
    
    <div style="margin-top: 50px; display: flex; justify-content: space-between; align-items: center;">
        <a href="home.jsp" style="color: #3498db; text-decoration: none;">← Keep Shopping</a>
        <% if (grandTotal.compareTo(BigDecimal.ZERO) > 0) { %>
            <a href="Checkout.jsp" class="btn-checkout">Proceed to Checkout</a>
        <% } %>
    </div>
</div>

</body>
</html>