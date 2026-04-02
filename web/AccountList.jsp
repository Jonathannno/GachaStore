<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, model.DBConnect" %>
<%
    String role = (String)session.getAttribute("role");
    if(role == null || !role.equals("admin")) { response.sendRedirect("home.jsp"); return; }
%>

<html>
<head>
    <title>Account Management | GachaStore Admin</title>
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .main-card { 
            background: white; 
            padding: 30px; 
            border-radius: 12px; 
            width: 90%; 
            max-width: 1200px; 
            margin: 30px auto; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
        }

        /* FORM STYLING */
        #addFormSection {
            display: none; 
            background: var(--light); 
            padding: 20px; 
            border-radius: 8px;
            margin-bottom: 25px; 
            border-left: 5px solid var(--success);
        }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #f4f6f7; color: var(--primary); padding: 15px; text-align: left; font-size: 18px;}
        td { padding: 12px; border-bottom: 1px solid #eee; }

        .unlockable { 
            border: 1px solid transparent; 
            background: transparent; 
            padding: 8px; 
            width: 100%; 
            color: #333; 
            pointer-events: none; 
            transition: 0.2s;
            font-family: inherit;
        }

        .active-row { background-color: #ebf5fb; }
        
        .active-row .unlockable { 
            border: 1px solid #3498db; 
            background: #fff; 
            pointer-events: auto; 
        }

        .btn { padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; font-family: inherit; }
        .btn-home { background: transparent; color: white; border: 1px solid white; }

        .status-msg { 
            background: #d1ecf1; 
            color: #0c5460; 
            padding: 10px; 
            border-radius: 5px; 
            margin-bottom: 15px; 
            border: 1px solid #bee5eb; 
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-left">
        <button class="btn btn-home" onclick="window.location.href='home.jsp'">← Back to Home</button>
        <span style="font-size: 1.5rem; font-weight: bold; margin-left:15px;">System Administration</span>
    </div>
    <button class="btn" style="background: var(--success); color: white;" onclick="toggleAddForm()">+ Create New Account</button>
</div>

<div class="main-card">
    <div id="addFormSection">
        <h3 style="margin-top:0;">Register New System User</h3>
        <form method="post" action="AccountServlet">
            <input type="hidden" name="action" value="insert">
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="user" placeholder="Username" required style="flex:2; padding:10px;">
                <input type="password" name="pass" placeholder="Password" required style="flex:2; padding:10px;">
                <select name="role" style="flex:1; padding:10px;">
                    <option value="user">User</option>
                    <option value="admin">Admin</option>
                </select>
                <button type="submit" class="btn" style="background: var(--success); color: white;">Confirm Add</button>
            </div>
        </form>
    </div>

    <form method="post" action="AccountServlet" id="accountForm">
        <table>
            <thead>
                <tr>
                    <th>Select</th><th>ID</th><th>Username</th><th>Password</th><th>Role</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = DBConnect.getConnection();
                    ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM accounts");
                    while(rs.next()){
                        int id = rs.getInt("id");
                %>
                <tr>
                    <td><input type="radio" name="selectedId" value="<%= id %>" onclick="unlockAccount(this)"></td>
                    <td><b><%= id %></b></td>
                    <td><input type="text" name="user_<%= id %>" value="<%= rs.getString("username") %>" class="unlockable" readonly></td>
                    <td>
                        <input type="password" name="pass_<%= id %>" value="<%= rs.getString("password") %>" 
                               class="unlockable" readonly 
                               onfocus="this.type='text'" onblur="this.type='password'">
                    </td>
                    <td>
                        <select name="role_<%= id %>" class="unlockable" disabled>
                            <option value="user" <%= "user".equals(rs.getString("role")) ? "selected" : "" %>>User</option>
                            <option value="admin" <%= "admin".equals(rs.getString("role")) ? "selected" : "" %>>Admin</option>
                        </select>
                    </td>
                </tr>
                <% } conn.close(); %>
            </tbody>
        </table>

        <div id="actionPanel" style="display:none; margin-top:30px;">
            <div class="status-msg">
                ℹ️ User Selection Unlocked: Changes will be applied to the selected ID only.
            </div>
            <div style="text-align: right;">
                <button type="submit" name="action" value="update" class="btn" style="background: var(--warning); color:white;">Save Changes</button>
                
                <button type="submit" name="action" value="delete" 
                        class="btn" style="background: var(--danger); color:white; margin-left:10px;" 
                        onclick="return confirmDelete()">Delete Account</button>
            </div>
        </div>
    </form>
</div>

<script>
    function toggleAddForm() {
        var section = document.getElementById("addFormSection");
        section.style.display = (section.style.display === "none" || section.style.display === "") ? "block" : "none";
    }

    function unlockAccount(radio) {

        document.querySelectorAll('tr').forEach(r => {
            r.classList.remove('active-row');
            var select = r.querySelector('select'); if(select) select.disabled = true;
            var inputs = r.querySelectorAll('.unlockable'); inputs.forEach(i => i.readOnly = true);
        });

        var row = radio.closest('tr');
        row.classList.add('active-row');
        var rowSelect = row.querySelector('select'); if(rowSelect) rowSelect.disabled = false;
        var rowInputs = row.querySelectorAll('.unlockable'); rowInputs.forEach(i => i.readOnly = false);
        document.getElementById("actionPanel").style.display = "block";
    }
    function confirmDelete() {
        const confirmMsg = "⚠️ CRITICAL ACTION ⚠️\n\nAre you sure you want to PERMANENTLY delete this user account?\nThis action cannot be undone.";
        return confirm(confirmMsg);
    }
    document.getElementById('accountForm').onsubmit = function(e) {
        this.querySelectorAll('.unlockable, select').forEach(el => {
            el.readOnly = false;
            el.disabled = false;
        });
    };
</script>

</body>
</html>