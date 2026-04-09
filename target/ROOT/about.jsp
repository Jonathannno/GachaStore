<%-- 
    Document   : about
    Created on : 9 thg 4, 2026, 14:37:32
    Author     : acer
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if(user == null) user = "Guest";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About Us | GachaStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @font-face {
            font-family: 'Aptos SemiBold';
            src: local('Aptos SemiBold'), local('Aptos-SemiBold');
        }

        :root {
            --shop-blue: #3498db;
            --dark-nav: #2c3e50;
            --price-red: #e74c3c;
            --soft-white: rgba(255, 255, 255, 0.96);
        }

        body {
            background: url("https://i.redd.it/wehif1rowai41.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Aptos SemiBold', 'Segoe UI', sans-serif;
            margin: 0;
            color: var(--dark-nav);
        }

        /* Standard Navbar matching home.jsp */
        .topnav {
            display: flex;
            align-items: center;
            background: var(--dark-nav);
            padding: 5px 40px;
        }
        .topnav a {
            color: white;
            padding: 15px 20px;
            text-decoration: none;
            transition: 0.3s;
        }
        .topnav a:hover {
            background: rgba(255,255,255,0.1);
        }

        /* Main Container matching the grid width */
        .main-container {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            background: var(--soft-white);
            padding: 50px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            box-sizing: border-box;
        }

        .about-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .about-header h1 {
            font-size: 42px;
            margin: 10px 0;
            color: var(--dark-nav);
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .divider {
            width: 80px;
            height: 4px;
            background: var(--shop-blue);
            margin: 20px auto;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 50px;
            align-items: center;
        }

        .text-section h2 {
            font-size: 28px;
            color: var(--shop-blue);
            margin-bottom: 20px;
        }

        .text-section p {
            line-height: 1.8;
            font-size: 18px;
            color: #444;
        }

        /* Professional Stats Bar */
        .stats-bar {
            display: flex;
            justify-content: space-around;
            background: var(--dark-nav);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin: 50px 0;
            text-align: center;
        }

        .stat-card i {
            font-size: 35px;
            color: var(--shop-blue);
            margin-bottom: 15px;
        }

        .stat-card h4 {
            margin: 10px 0;
            font-size: 20px;
        }

        .stat-card p {
            font-size: 14px;
            opacity: 0.8;
        }

        .footer-note {
            text-align: center;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid #ddd;
        }

        .btn-return {
            display: inline-block;
            padding: 12px 30px;
            background: var(--shop-blue);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn-return:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<div class="topnav">
    <a href="home.jsp">Home</a>
    <a href="about.jsp" style="border-bottom: 3px solid var(--shop-blue);">About Us</a>
    <a href="Cart.jsp">My Cart</a>
</div>

<div class="main-container">
    <div class="about-header">
        <i class="fa-solid fa-store" style="font-size: 40px; color: var(--shop-blue);"></i>
        <h1>Our Story</h1>
        <div class="divider"></div>
        <p style="font-size: 20px; color: #666;">Serving the Rhodes Island Community since 2024</p>
    </div>

    <div class="content-grid">
        <div class="text-section">
            <h2>Who We Are</h2>
            <p>
                GachaStore began as a small passion project among Arknights enthusiasts in Vietnam. 
                Tired of the uncertainty and long wait times of overseas shipping, we set out to 
                create a localized, professional hub for authentic game merchandise.
            </p>
            <p>
                Today, we are proud to be a leading distributor of licensed figures, apparel, and 
                collectibles. We don't just sell products; we share the excitement of every "Top-up" 
                and the joy of unboxing a long-awaited 1/7 scale operator.
            </p>
        </div>
        <div class="image-section">
            <img src="https://i.pinimg.com/originals/94/a4/ce/94a4ce432b4984f18d5f3d3864a7873b.jpg" 
                 style="width:100%; border-radius:12px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);" 
                 alt="Rhodes Island Art">
        </div>
    </div>

    <div class="stats-bar">
        <div class="stat-card">
            <i class="fa-solid fa-certificate"></i>
            <h4>100% Official</h4>
            <p>No bootlegs. Ever.</p>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-box-open"></i>
            <h4>Safe Packaging</h4>
            <p>Double-boxed for safety</p>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-headset"></i>
            <h4>Doctor Support</h4>
            <p>Collectors helping collectors</p>
        </div>
    </div>

    <div class="text-section" style="text-align: center; max-width: 800px; margin: 0 auto;">
        <h2>Our Commitment</h2>
        <p>
            Every item in our inventory is inspected for quality and authenticity. We know how 
            much these characters mean to you because they mean the same to us. From Amiya to 
            Surtr, your favorite operators are in good hands at GachaStore.
        </p>
    </div>

    <div class="footer-note">
        <a href="home.jsp" class="btn-return">
            <i class="fa-solid fa-arrow-left"></i> Back to Main Store
        </a>
    </div>
</div>

</body>
</html>