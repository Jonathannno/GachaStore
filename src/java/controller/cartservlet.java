package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DBConnect;

@WebServlet(urlPatterns = {"/cartservlet"})
public class cartservlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        String action = request.getParameter("action");
        String pIdRaw = request.getParameter("productId");

        try (Connection conn = DBConnect.getConnection()) {
            int productId = (pIdRaw != null) ? Integer.parseInt(pIdRaw) : 0;

            // 1. ACTION: DELETE ITEM
            if ("delete".equals(action)) {
                String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.executeUpdate();

            // 2. ACTION: UPDATE QUANTITY (Fixed Minus/Plus Logic)
            } else if ("update".equals(action)) {
    String qtyParam = request.getParameter("quantity");
    if (qtyParam == null || qtyParam.isEmpty()) {
        response.sendRedirect("Cart.jsp");
        return;
    }

    int requestedQty = Integer.parseInt(qtyParam);
    
    // DEBUG: Check your Output window in NetBeans to see this!
    System.out.println("DEBUG: Updating Product " + productId + " to Qty: " + requestedQty);

    if (requestedQty <= 0) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ps.executeUpdate();
    } else {
        int currentStock = getProductStock(conn, productId);
        
        if (requestedQty > currentStock) {
            response.sendRedirect("Cart.jsp?error=exceed_stock&max=" + currentStock);
            return;
        } else {
            // THE FIX: Ensure the WHERE clause is specific enough
            String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestedQty);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            
            int rowsUpdated = ps.executeUpdate();
            System.out.println("DEBUG: Rows affected: " + rowsUpdated);
        }
    }

            // 3. ACTION: ADD ITEM
            } else if ("add".equals(action)) {
                int currentStock = getProductStock(conn, productId);
                int currentInCart = getQtyInCart(conn, userId, productId);

                if (currentInCart + 1 > currentStock) {
                    response.sendRedirect("Cart.jsp?error=exceed_stock&max=" + currentStock);
                    return;
                }

                String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, 1) "
                           + "ON DUPLICATE KEY UPDATE quantity = quantity + 1";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.executeUpdate();
            }

            response.sendRedirect("Cart.jsp");

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }

    private int getProductStock(Connection conn, int productId) throws Exception {
        String sql = "SELECT quantity FROM products WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        }
    }

    private int getQtyInCart(Connection conn, int userId, int productId) throws Exception {
        String sql = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}