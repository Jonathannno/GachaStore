<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, model.DBConnect, java.math.BigDecimal, java.text.DecimalFormat" %>

<%
String role = (String)session.getAttribute("role");
if(role == null || !role.equals("admin")) {
    response.sendRedirect("home.jsp");
    return;
}

String query = request.getParameter("query");
String sort = request.getParameter("sort");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<html>
<head>
    <title>Inventory Management | Admin Console</title>
    <style>

        @font-face {
            font-family: 'Aptos SemiBold';
            src: local('Aptos SemiBold'), local('Aptos-SemiBold');
        }

        :root {
            --primary: #2c3e50;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --light: #f8f9fa;
        }

        body {
            background: #f0f2f5;
            font-family: 'Aptos SemiBold', 'Segoe UI', sans-serif;
            margin: 0;
        }

        .navbar {
            background: var(--primary);
            padding: 15px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar form input, .navbar form select {
            padding: 8px;
            border-radius: 6px;
            border: none;
            font-family: inherit;
        }

        .main-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            width: 95%;
            margin: 30px auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #f4f6f7; padding: 15px; font-size: 16px; border-bottom: 2px solid #ddd; }
        td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }

        .unlockable {
            pointer-events: none;
            border: 1px solid transparent;
            background: transparent;
            text-align: center;
            width: 100%;
            font-family: inherit;
            padding: 5px;
        }

        .active-row { background-color: #f0f7ff; }
        .active-row .unlockable {
            pointer-events: auto;
            border: 1px solid #3498db;
            background: white;
            border-radius: 4px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            border-radius: 8px;
            font-weight: bold;
            font-family: inherit;
            transition: 0.2s;
        }

        .btn-update { background: var(--warning); color: white; }
        .btn-delete { background: var(--danger); color: white; margin-left: 10px; }

        .product-img {
            width: 80px; height: 80px;
            object-fit: contain;
            border-radius: 8px;
            background: #fff;
        }

        .add-bar {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            border: 1px solid #e9ecef;
        }

        .add-bar input { padding: 10px; border: 1px solid #ddd; border-radius: 6px; flex: 1; 
        
                         .status-msg { 
    background: #d1ecf1; 
    color: #0c5460; 
    padding: 12px; 
    border-radius: 8px; 
    margin-bottom: 20px; 
    border: 1px solid #bee5eb; 
    font-weight: bold;
    display: flex;
    align-items: center;
    gap: 10px;
}
        }
    </style>
</head>

<body>

<div class="navbar">
    <div>
        <button class="btn" style="background:rgba(255,255,255,0.2)" onclick="window.location.href='home.jsp'">← Home</button>
        <b style="font-size: 20px; margin-left: 15px;">Inventory Manager</b>
    </div>

    <form method="get" style="margin:0;">
        <input type="text" name="query" placeholder="Find product..." value="<%= (query != null) ? query : "" %>">
        <select name="sort">
            <option value="id_desc">Newest First</option>
            <option value="price_asc">Price: Low to High</option>
            <option value="price_desc">Price: High to Low</option>
        </select>
        <button type="submit" class="btn" style="background: var(--success);">Filter</button>
    </form>
</div>

<div class="main-card">

    <h3 style="margin-top:0;">Quick Add Product</h3>
    <form method="post" action="ProductServlet" enctype="multipart/form-data" class="add-bar">
        <input type="hidden" name="action" value="insert">
        <input type="text" name="name" placeholder="Item Name" required>
        <input type="number" step="0.001" name="price" placeholder="Price (VND)" required>
        <input type="number" name="qty" placeholder="Qty" required style="max-width: 80px;">
        <input type="date" name="date" required>
        <input type="file" name="image" accept="image/*" required style="flex:2;">
        <button type="submit" class="btn" style="background: var(--success); color:white;">+ Add to Stock</button>
    </form>

    <br>

    <form method="post" action="ProductServlet" id="productForm">
        <table>
            <thead>
                <tr>
                    <th>Select</th>
                    <th>ID</th>
                    <th>Thumbnail</th>
                    <th>Product Name</th>
                    <th>Price (VND)</th>
                    <th>Stock</th>
                    <th>Date</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    conn = DBConnect.getConnection();
                    String sql = "SELECT * FROM products WHERE 1=1";
                    if (query != null && !query.trim().isEmpty()) sql += " AND name LIKE ?";
                    
                    if ("price_asc".equals(sort)) sql += " ORDER BY price ASC";
                    else if ("price_desc".equals(sort)) sql += " ORDER BY price DESC";
                    else sql += " ORDER BY id DESC";

                    ps = conn.prepareStatement(sql);
                    if (query != null && !query.trim().isEmpty()) ps.setString(1, "%" + query + "%");
                    rs = ps.executeQuery();

                    
                    DecimalFormat df = new DecimalFormat("#,##0.###");

                    while(rs.next()) {
                        int id = rs.getInt("id");
                        BigDecimal pPrice = rs.getBigDecimal("price");
                        if(pPrice == null) pPrice = BigDecimal.ZERO;
                %>
                <tr>
                    <td><input type="radio" name="selectedId" value="<%= id %>" onclick="unlockRow(this)"></td>
                    <td><%= id %></td>
                    <td>
                        <img class="product-img"
                             src="<%= request.getContextPath() %>/images/<%= rs.getString("image") %>"
                             onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">
                    </td>
                    <td><input type="text" name="name_<%= id %>" value="<%= rs.getString("name") %>" class="unlockable" readonly></td>
                    <td>
                        <input type="text" name="price_text_<%= id %>" value="<%= df.format(pPrice) %>" class="unlockable" readonly>
                        <input type="hidden" name="price_<%= id %>" value="<%= pPrice %>">
                    </td>
                    <td><input type="number" name="qty_<%= id %>" value="<%= rs.getInt("quantity") %>" class="unlockable" readonly></td>
                    <td><input type="date" name="date_<%= id %>" value="<%= rs.getDate("date") %>" class="unlockable" readonly></td>
                    <td><input type="text" name="description_<%= id %>" value="<%= rs.getString("description") %>" class="unlockable" readonly></td>
                </tr>
                <%
                    }
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    try { if(rs != null) rs.close(); } catch(Exception e){}
                    try { if(ps != null) ps.close(); } catch(Exception e){}
                    try { if(conn != null) conn.close(); } catch(Exception e){}
                }
                %>
            </tbody>
        </table>

        <div id="actionPanel" style="display:none; margin-top:30px;">
    <div class="status-msg">
        <span>ℹ️ Product Selection Unlocked: You can now modify details or remove this item from inventory.</span>
    </div>

    <div style="text-align: right;">
        <button type="submit" name="action" value="update" class="btn btn-update">
            Save Changes
        </button>
        <button type="submit" name="action" value="delete" class="btn btn-delete" onclick="return confirmDelete()">
            Delete Product
        </button>
    </div>
</div>
    </form>
</div>

<script>
function unlockRow(radio){
    document.querySelectorAll('tr').forEach(r => r.classList.remove('active-row'));
    document.querySelectorAll('.unlockable').forEach(i => i.readOnly = true);

    let row = radio.closest('tr');
    row.classList.add('active-row');
    row.querySelectorAll('.unlockable').forEach(i => i.readOnly = false);

    document.getElementById("actionPanel").style.display = "block";
}

function confirmDelete() {
    return confirm("❗ WARNING: This will permanently remove the product from the catalog.\n\nAre you sure you want to proceed?");
}

document.getElementById('productForm').onsubmit = function() {
    this.querySelectorAll('.unlockable').forEach(i => i.readOnly = false);
};
</script>

</body>
</html>