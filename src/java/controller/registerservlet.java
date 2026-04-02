package controller;

import model.DBConnect;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/RegisterServlet")
public class registerservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();

            String checkSql = "SELECT * FROM accounts WHERE username=?";
            PreparedStatement check = conn.prepareStatement(checkSql);
            check.setString(1, username);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {  
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println(
                    "<script>alert('Username already exists!'); window.location='register.jsp';</script>"
                );
                return;
            }

            String sql = "INSERT INTO accounts (username, password, role) VALUES (?, ?, 'user')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ps.executeUpdate();
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}