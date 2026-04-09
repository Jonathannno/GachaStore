<%-- 
    Document   : success
    Created on : 2 thg 4, 2026, 16:15:30
    Author     : acer
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%
    // Get the Order ID passed from the Servlet
    String orderId = request.getParameter("orderId");
    if (orderId == null) orderId = "N/A";
    
    // Get current date for the receipt
    String date = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed | GachaStore</title>
    <style>
        body { 
            font-family: 'Aptos SemiBold', 'Segoe UI', sans-serif; 
            background: #f4f7f6; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        .success-card { 
            background: white; 
            max-width: 550px; 
            width: 90%; 
            padding: 40px; 
            border-radius: 20px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            text-align: center; 
            border-top: 8px solid #27ae60;
        }
        .icon-circle {
            width: 80px;
            height: 80px;
            background: #e8f6ed;
            color: #27ae60;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin: 0 auto 20px;
        }
        h2 { color: #2c3e50; margin-bottom: 10px; }
        p { color: #7f8c8d; line-height: 1.6; }
        
        .order-info {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            text-align: left;
            border: 1px dashed #ddd;
        }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 5px; }
        .label { font-weight: bold; color: #34495e; }
        
        .trust-message {
            font-style: italic;
            color: #2c3e50;
            margin-top: 30px;
            padding: 15px;
            border-top: 1px solid #eee;
        }
        
        .btn-return {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #2c3e50;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            transition: 0.3s;
            font-weight: bold;
        }
        .btn-return:hover { background: #34495e; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="success-card">
    <div class="icon-circle">✓</div>
    <h2>Mission Accomplished!</h2>
    <p>Your order has been successfully processed and recorded.</p>

    <div class="order-info">
        <div class="info-row">
            <span class="label">Order ID:</span>
            <span>#<%= orderId %></span>
        </div>
        <div class="info-row">
            <span class="label">Date:</span>
            <span><%= date %></span>
        </div>
        <div class="info-row">
            <span class="label">Status:</span>
            <span style="color: #27ae60; font-weight: bold;">Confirmed</span>
        </div>
    </div>

    <div class="trust-message">
        "Thank you for putting your trust in our little shop. <br>
        We are honored to serve a dedicated Doctor like you!"
    </div>

    <a href="home.jsp" class="btn-return">Return to Headquarters</a>
</div>

</body>
</html>