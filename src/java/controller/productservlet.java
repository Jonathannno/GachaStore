package controller;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnect;

@WebServlet("/ProductServlet")
@MultipartConfig
public class productservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String id = request.getParameter("selectedId");

        try (Connection conn = DBConnect.getConnection()) {

            if ("insert".equals(action)) {

                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int qty = Integer.parseInt(request.getParameter("qty"));
                Date date = Date.valueOf(request.getParameter("date"));

                // IMAGE UPLOAD
                Part filePart = request.getPart("image");
                String fileName = "";

                if (filePart != null && filePart.getSize() > 0) {
                    fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

                    String uploadPath = getServletContext().getRealPath("") + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    filePart.write(uploadPath + File.separator + fileName);
                }

                String sql = "INSERT INTO products (name, price, quantity, date, description, image) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setString(1, name);
                ps.setDouble(2, price);
                ps.setInt(3, qty);
                ps.setDate(4, date);
                ps.setString(5, "");
                ps.setString(6, fileName);

                ps.executeUpdate();
            }

            else if ("update".equals(action) && id != null) {

                String name = request.getParameter("name_" + id);
                double price = Double.parseDouble(request.getParameter("price_" + id));
                int qty = Integer.parseInt(request.getParameter("qty_" + id));
                Date date = Date.valueOf(request.getParameter("date_" + id));
                String desc = request.getParameter("description_" + id);

                String sql = "UPDATE products SET name=?, price=?, quantity=?, date=?, description=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setString(1, name);
                ps.setDouble(2, price);
                ps.setInt(3, qty);
                ps.setDate(4, date);
                ps.setString(5, desc);
                ps.setInt(6, Integer.parseInt(id));

                ps.executeUpdate();
            }

            else if ("delete".equals(action) && id != null) {

                String sql = "DELETE FROM products WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProductList.jsp");
    }
}