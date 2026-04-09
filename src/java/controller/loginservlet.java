package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import model.DBConnect;

@WebServlet("/LoginServlet")
public class loginservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {

            Connection conn = DBConnect.getConnection();

            String sql = "SELECT * FROM accounts WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();

                session.setAttribute("user", username);
                session.setAttribute("role", rs.getString("role"));

                session.setAttribute("userId", rs.getInt("id")); 
                // --------------------------

                response.sendRedirect("home.jsp");

            
            } else {

                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();

                out.println("<script>");
                out.println("alert('Login failed! Username or password incorrect');");
                out.println("window.location='login.jsp';");
                out.println("</script>");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}