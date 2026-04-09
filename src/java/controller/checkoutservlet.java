package controller;

import java.io.IOException;
import java.sql.*;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnect;

@WebServlet("/CheckoutServlet")
public class checkoutservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 1. Get the Form Data from Checkout.jsp
        String totalRaw = request.getParameter("totalAmount");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        // Basic validation to prevent empty orders
        if (userId == null || totalRaw == null || fullName == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 2. CREATE THE ORDER HEADER (Now with user details)
            // Note: Ensure your SQL table has these columns!
            String orderSql = "INSERT INTO orders (user_id, total_amount, full_name, phone, address, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setBigDecimal(2, new BigDecimal(totalRaw));
            psOrder.setString(3, fullName);
            psOrder.setString(4, phone);
            psOrder.setString(5, address);
            psOrder.setString(6, paymentMethod);
            psOrder.executeUpdate();

            // Get the generated Order ID
            ResultSet rsKeys = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rsKeys.next()) { 
                orderId = rsKeys.getInt(1); 
            }

            // 3. PROCESS ITEMS: MOVE FROM CART -> ORDER_DETAILS & REDUCE STOCK
            String cartSql = "SELECT product_id, quantity FROM cart WHERE user_id = ?";
            PreparedStatement psCart = conn.prepareStatement(cartSql);
            psCart.setInt(1, userId);
            ResultSet rsCart = psCart.executeQuery();

            while (rsCart.next()) {
                int pId = rsCart.getInt("product_id");
                int qty = rsCart.getInt("quantity");

                // Get current stock and price to prevent "phantom" purchases
                String productSql = "SELECT price, quantity FROM products WHERE id = ?";
                PreparedStatement psProd = conn.prepareStatement(productSql);
                psProd.setInt(1, pId);
                ResultSet rsProd = psProd.executeQuery();
                
                if (rsProd.next()) {
                    BigDecimal currentPrice = rsProd.getBigDecimal("price");
                    int stockLeft = rsProd.getInt("quantity");

                    // FINAL STOCK GUARD
                    if (stockLeft < qty) {
                        throw new Exception("Stock ran out for an item during processing!");
                    }

                    // A. Record the line item
                    String detailSql = "INSERT INTO order_details (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
                    PreparedStatement psDetail = conn.prepareStatement(detailSql);
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, pId);
                    psDetail.setInt(3, qty);
                    psDetail.setBigDecimal(4, currentPrice);
                    psDetail.executeUpdate();

                    // B. Deduct from Inventory
                    String updateStock = "UPDATE products SET quantity = quantity - ? WHERE id = ?";
                    PreparedStatement psUpdate = conn.prepareStatement(updateStock);
                    psUpdate.setInt(1, qty);
                    psUpdate.setInt(2, pId);
                    psUpdate.executeUpdate();
                }
            }

            // 4. CLEANUP: EMPTY THE TRAY
            String clearCart = "DELETE FROM cart WHERE user_id = ?";
            PreparedStatement psClear = conn.prepareStatement(clearCart);
            psClear.setInt(1, userId);
            psClear.executeUpdate();

            // 5. COMMIT: SAVE ALL CHANGES AT ONCE
            conn.commit(); 
            response.sendRedirect("success.jsp?orderId=" + orderId);

        } catch (Exception e) {
            // If anything failed, undo everything (Rollback)
            if (conn != null) { 
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } 
            }
            e.printStackTrace();
            response.sendRedirect("Cart.jsp?error=checkout_failed");
        } finally {
            if (conn != null) { 
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } 
            }
        }
    }
}