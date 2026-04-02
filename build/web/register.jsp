<%-- 
    Document   : registerjsp
    Created on : 5 thg 3, 2026, 13:15:22
    Author     : acer
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - GachaStore</title>
    <style>
        :root {
            --success-green: #2ecc71;
            --glass-white: rgba(255, 255, 255, 0.85);
        }

        body {
            background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), 
                        url("https://i.redd.it/wehif1rowai41.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .register-container {
            width: 100%;
            max-width: 400px;
            background: var(--glass-white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.3);
            text-align: center;
        }

        .logo {
            width: 250px;
            margin-bottom: 20px;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-weight: 700;
        }

        .highlight { color: var(--success-green); }

        form { text-align: left; }

        label {
            font-weight: 600;
            color: #34495e;
            display: block;
            margin-bottom: 5px;
        }

        input[type=text], input[type=password] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: rgba(255,255,255,0.9);
            box-sizing: border-box;
        }

        .big-btn {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            background: var(--success-green);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
        }

        .big-btn:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }

        .login-link {
            display: block;
            margin-top: 20px;
            color: #7f8c8d;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .login-link:hover { color: var(--success-green); }
    </style>
</head>
<body>

<div class="register-container">
    <img src="images/Arknights_Logo.png" class="logo">
    <h1><span class="highlight">Join Us</span></h1>

    <form action="RegisterServlet" method="post">
        <label>Choose Username</label>
        <input type="text" name="username" required>

        <label>Set Password</label>
        <input type="password" name="password" required>

        <button type="submit" class="big-btn">Create Account</button>
    </form>

    <a class="login-link" href="login.jsp">Already have an account? Login here</a>
</div>

</body>
</html>