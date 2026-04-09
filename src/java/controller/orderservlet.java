package controller;

import java.io.IOException;
import java.sql.*;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnect;

@WebServlet("/OrderServlet")
public class orderservlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get info from the Credential Box
        // Inside your doPost method in OrderServlet.java
String name = request.getParameter("fullName");
String email = request.getParameter("email"); // If you don't have an email col, this just stays local
String addr = request.getParameter("address");
String phone = request.getParameter("phone");
String payment = request.getParameter("paymentMethod"); // We need to add this to Checkout.jsp!

try (Connection conn = DBConnect.getConnection()) {
    conn.setAutoCommit(false); 

    // 1. Get the total price from the cart to save into total_amount
    BigDecimal total = BigDecimal.ZERO;
    PreparedStatement psTotal = conn.prepareStatement(
        "SELECT SUM(p.price * c.quantity) FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?");
    psTotal.setInt(1, userId);
    ResultSet rs = psTotal.executeQuery();
    if(rs.next()) total = rs.getBigDecimal(1);

    // 2. Insert into orders (Matches your 9 columns + ID/Date auto-filled)
    String sql = "INSERT INTO orders (user_id, total_amount, status, full_name, phone, address, payment_method) " +
             "VALUES (?, ?, 'Complete', ?, ?, ?, ?)";
    PreparedStatement psOrder = conn.prepareStatement(sql);
    psOrder.setInt(1, userId);
    psOrder.setBigDecimal(2, total);
    psOrder.setString(3, name);
    psOrder.setString(4, phone);
    psOrder.setString(5, addr);
    psOrder.setString(6, payment != null ? payment : "Unknown");
    psOrder.executeUpdate();

    // 3. Update Stock
    PreparedStatement psStock = conn.prepareStatement(
        "UPDATE products p JOIN cart c ON p.id = c.product_id SET p.quantity = p.quantity - c.quantity WHERE c.user_id = ?");
    psStock.setInt(1, userId);
    psStock.executeUpdate();

    // 4. Clear Cart
    PreparedStatement psClear = conn.prepareStatement("DELETE FROM cart WHERE user_id = ?");
    psClear.setInt(1, userId);
    psClear.executeUpdate();

    conn.commit(); 
    response.sendRedirect("success.jsp");

} catch (Exception e) {
    e.printStackTrace(); // CHECK THE NETBEANS OUTPUT FOR ERRORS HERE
    response.sendRedirect("Checkout.jsp?error=fail");
        }
    }
}