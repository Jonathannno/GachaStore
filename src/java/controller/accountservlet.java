package controller; 

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnect;

@WebServlet("/AccountServlet")
public class accountservlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String id = request.getParameter("selectedId");
        
        try (Connection conn = DBConnect.getConnection()) {
            if ("insert".equals(action)) {
                String sql = "INSERT INTO accounts (username, password, role) VALUES (?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("user"));
                ps.setString(2, request.getParameter("pass"));
                ps.setString(3, request.getParameter("role"));
                ps.executeUpdate();
            }

            else if ("update".equals(action) && id != null) {
                String sql = "UPDATE accounts SET username=?, password=?, role=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("user_" + id));
                ps.setString(2, request.getParameter("pass_" + id));
                ps.setString(3, request.getParameter("role_" + id));
                ps.setInt(4, Integer.parseInt(id));
                ps.executeUpdate();
            }

            else if ("delete".equals(action) && id != null) {
                String sql = "DELETE FROM accounts WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("AccountList.jsp");
    }
}