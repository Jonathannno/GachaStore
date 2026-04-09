<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, model.DBConnect" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String user = (String) session.getAttribute("user");
    if(user == null) user = "Guest";

    double totalAmount = 0;
    int totalItems = 0;

    if (userId != null) {
        try (Connection conn = DBConnect.getConnection()) {
            // This query calculates the sum and counts items in one go
            String sql = "SELECT SUM(p.price * c.quantity) as total, SUM(c.quantity) as count " +
                         "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalAmount = rs.getDouble("total");
                totalItems = rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout | GachaStore</title>

<style>
    :root {
        --shop-blue: #3498db;
        --dark: #2c3e50;
        --success: #2ecc71;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f4f6f9;
        margin: 0;
    }

    .navbar {
        background: var(--dark);
        color: white;
        padding: 15px 40px;
    }

    .container {
        width: 85%;
        max-width: 900px;
        margin: 40px auto;
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }

    /* PRODUCT SUMMARY */
    .product-box {
        display: flex;
        gap: 20px;
        align-items: center;
        padding: 15px;
        border: 1px solid #eee;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    
    /* Container for the three images */
.payment-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    margin: 20px 0;
}

/* Specific specs for the side images */
.side-image {
    width: 240px;  /* Your specified width */
    height: 240px; /* Your specified height */
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid #eee;
}

/* Ensure the bank list (center) stays compact */
.bank-list-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
}
    .product-box img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
    .price { color: #e74c3c; font-weight: bold; font-size: 1.2rem; }

    /* BANK ICONS */
    .bank-list {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 15px;
    }

    .bank-list img {
        width: 70px;
        height: 70px;
        object-fit: contain;
        background: white;
        padding: 8px;
        border-radius: 10px;
        border: 2px solid #ddd;
        transition: 0.3s;
        cursor: pointer;
    }

    /* Highlight selected bank */
    .bank-list img.selected {
        border-color: var(--shop-blue);
        background: #ebf5fb;
        transform: scale(1.05);
    }

    /* FORM STYLING */
    #info-section {
        display: none; /* Hidden by default */
        margin-top: 30px;
        padding-top: 20px;
        border-top: 2px dashed #eee;
    }

    .input-group {
        margin-bottom: 15px;
        text-align: left;
    }

    .input-group label { display: block; margin-bottom: 5px; font-weight: 600; }
    .input-group input, .input-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
    }

    /* BUTTONS */
    #btn-make-purchase {
        display: none; /* Pop out later */
        margin-top: 25px;
        background: var(--dark);
    }

    .btn-main {
        padding: 15px 30px;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        font-size: 1rem;
        transition: 0.3s;
    }

    .btn-main:hover { opacity: 0.9; transform: translateY(-2px); }
    .btn-confirm { background: var(--success); width: 100%; margin-top: 20px; }

</style>
</head>

<body>

<div class="navbar">
    <h2>Checkout Process</h2>
</div>

<div class="container" style="text-align: center;">

    <h3>Welcome, <%= user %></h3>

    <div class="product-box">
    <img src="<%= request.getContextPath() %>/images/cart-icon.png" onerror="this.src='images/default.jpg'">
    <div style="text-align: left;">
        <h3 style="margin:0;">Order Summary (<%= totalItems %> items)</h3>
        <p class="price">
            <%= String.format("%,.0f", totalAmount) %> VND
        </p>
    </div>
</div>

    <div id="payment-section">
    <h3>1. Select Payment Method</h3>
    
    <div class="payment-row">
        <img src="images/payment-decor.png" class="side-image" alt="Promo Left">

        <div class="bank-list-wrapper">
            <div class="bank-list" id="bankList">
                <img src="images/vietcombank.jpg" onclick="selectBank(this)">
                <img src="images/techcombank.png" onclick="selectBank(this)">
                <img src="images/bidv.png" onclick="selectBank(this)">
                <img src="images/momo.png" onclick="selectBank(this)">
            </div>
        </div>

        <img src="images/qr.jpg" class="side-image" alt="Promo Right">
    </div>

    <button id="btn-make-purchase" class="btn-main" onclick="showInfoForm()">
        Make Purchase
    </button>
</div>

        <button id="btn-make-purchase" class="btn-main" onclick="showInfoForm()">
            Make Purchase
        </button>
    </div>

    <div id="info-section">
    <h3>2. Shipping Information</h3>
    <form action="OrderServlet" method="POST">
    <input type="hidden" name="paymentMethod" id="paymentInput" value="Not Selected">
    
    <div class="input-group">
        <label>Full Name</label>
            <input type="text" name="fullName" placeholder="John Doe" required>
        </div>
        <div class="input-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="john@example.com" required>
        </div>
        <div class="input-group">
            <label>Delivery Address</label>
            <textarea name="address" rows="3" placeholder="123 Street, HCM City" required></textarea>
        </div>
        <div class="input-group">
            <label>Contact Phone</label>
            <input type="text" name="phone" placeholder="0901234567" required>
        </div>

        <button type="submit" class="btn-main btn-confirm">
            Finalize & Pay Now
        </button>
    </form>
</div>

</div>

<script>
    function selectBank(element) {
    const banks = document.querySelectorAll('.bank-list img');
    banks.forEach(img => img.classList.remove('selected'));
    element.classList.add('selected');

    // NEW PART: Get the name from the image and save it to the hidden input
    // This takes "images/momo.png" and extracts "momo"
    const bankName = element.src.split('/').pop().split('.')[0]; 
    document.getElementById('paymentInput').value = bankName;

    document.getElementById('btn-make-purchase').style.display = 'inline-block';
    window.scrollBy({ top: 100, behavior: 'smooth' });
}

    function showInfoForm() {
        // Hide the purchase button so they don't click twice
        document.getElementById('btn-make-purchase').style.display = 'none';
        
        // Show the info section
        const infoSection = document.getElementById('info-section');
        infoSection.style.display = 'block';

        // Smooth scroll to the form
        infoSection.scrollIntoView({ behavior: 'smooth' });
    }
</script>

</body>
</html>