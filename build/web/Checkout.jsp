<%-- 
    Document   : Checkout
    Created on : 2 thg 4, 2026, 15:21:18
    Author     : acer
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, model.DBConnect, java.math.BigDecimal, java.text.DecimalFormat" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userEmail = (String) session.getAttribute("userEmail"); // Assuming stored at login
    if (userId == null) { response.sendRedirect("login.jsp"); return; }
    DecimalFormat df = new DecimalFormat("#,##0.###");
    BigDecimal total = BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Shipping & Payment | GachaStore</title>
    <style>
        body { font-family: 'Aptos SemiBold', sans-serif; background: #f4f7f6; padding: 40px; }
        .checkout-container { max-width: 900px; margin: auto; display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .box { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        h3 { border-bottom: 2px solid #eee; padding-bottom: 10px; margin-top: 0; }
        input, select { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-confirm { background: #27ae60; color: white; padding: 15px; border: none; border-radius: 8px; width: 100%; cursor: pointer; font-size: 16px; font-weight: bold; }
    </style>
</head>
<body>

<div class="checkout-container">
    <div class="box">
        <h3>Shipping Details 🚚</h3>
        <form action="CheckoutServlet" method="POST">
            <input type="text" name="fullName" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email Address" value="<%= (userEmail != null) ? userEmail : "" %>" required>
            <input type="text" name="phone" placeholder="Phone Number" required>
            <input type="text" name="address" placeholder="Shipping Address (Street, District, City)" required>
            
            <h3 style="margin-top: 30px;">Payment Method 💳</h3>
            <select name="paymentMethod" required>
                <option value="">-- Choose Payment --</option>
                <option value="COD">Cash on Delivery (COD)</option>
                <option value="MOMO">Momo Wallet</option>
                <option value="BANK">Bank Transfer (VNPAY)</option>
                <option value="CREDITS">GachaStore Credits</option>
            </select>

            <input type="hidden" name="totalAmount" value="<%= total %>"> <%-- This will be updated by the logic below --%>
            <button type="submit" class="btn-confirm">CONFIRM PURCHASE</button>
        </form>
    </div>

    <div class="box">
        <h3>Order Summary</h3>
        <div style="max-height: 400px; overflow-y: auto;">
            <%
            try (Connection conn = DBConnect.getConnection()) {
                String sql = "SELECT p.name, p.price, c.quantity FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    BigDecimal sub = rs.getBigDecimal("price").multiply(new BigDecimal(rs.getInt("quantity")));
                    total = total.add(sub);
                    out.println("<div style='display:flex; justify-content:space-between; margin-bottom:10px;'>");
                    out.println("<span>" + rs.getString("name") + " x" + rs.getInt("quantity") + "</span>");
                    out.println("<span>" + df.format(sub) + " VND</span>");
                    out.println("</div>");
                }
            } catch(Exception e) { e.printStackTrace(); }
            %>
        </div>
        <hr>
        <div style="display:flex; justify-content:space-between; font-size: 20px; font-weight: bold; color: #e74c3c;">
            <span>Total:</span>
            <span><%= df.format(total) %> VND</span>
        </div>
        <%-- Important: We need to re-pass the total to the form hidden input via JS or just calculate it before the form in JSP --%>
    </div>
</div>

</body>
</html>