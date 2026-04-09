<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login - GachaStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #3498db;
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

        .login-container {
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

        .highlight { color: var(--primary-blue); }

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

        .password-wrapper {
            position: relative;
            margin-bottom: 20px; 
        }

        .password-wrapper input {
            margin-bottom: 0 !important;
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #7f8c8d;
            z-index: 10;
        }

        .toggle-password:hover { color: var(--primary-blue); }

        .big-btn {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            background: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
            margin-top: 10px;
        }

        .big-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .register-link {
            display: block;
            margin-top: 20px;
            color: #7f8c8d;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .register-link:hover { color: var(--primary-blue); }
    </style>
</head>
<body>

<div class="login-container">
    <img src="images/Arknights_Logo.png" class="logo">
    <h1><span class="highlight">Login</span></h1>

    <form action="LoginServlet" method="post">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <div class="password-wrapper">
            <input type="password" name="password" id="password" required>
            <i class="fa-solid fa-eye toggle-password" id="eyeIcon"></i>
        </div>

        <button type="submit" class="big-btn">Login</button>
    </form>

    <a class="register-link" href="register.jsp">New to GachaStore? Create an account</a>
</div>

<script>
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');

    eyeIcon.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
</script>

</body>
</html>