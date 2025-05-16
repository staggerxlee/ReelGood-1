<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReelGood - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
      body {
        background-image: url('<%= request.getContextPath() %>/images/login-background.jpg') !important;
        background-size: cover !important;
        background-attachment: fixed !important;
        background-color: #181012 !important;
      }
    </style>
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <div class="login-form-container">    
                <div class="login-form-section active" id="login-section">
                    <picture>
                        <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="logo" style="width: 200px; height: 200px;" class="center"> 
                    </picture>
                    <form id="login-form" action="<%= request.getContextPath() %>/login" method="post">
                        <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/user/index">
                        <div class="login-form-group">
                            <label for="login-email">Email</label>
                            <div class="login-input-group">
                                <i class="fa-solid fa-envelope login-icon"></i>
                                <input type="email" id="login-email" name="email" required>
                                <span class="login-error-message"></span>
                            </div>
                        </div>
                        <div class="login-form-group">
                            <label for="login-password">Password</label>
                            <div class="login-input-group">
                                <i class="fa-solid fa-lock login-icon"></i>
                                <input type="password" id="login-password" name="password" required>
                                <i class="fa-solid fa-eye login-toggle-password"></i>
                                <span class="login-error-message"></span>
                            </div>
                        </div>
                        <div class="login-forgot-password">
                            <a href="#">Forgot password?</a>
                        </div>
                        <button type="submit" class="login-submit-btn">
                            <span>Login</span>
                            <i class="fa-solid fa-arrow-right"></i>
                        </button>
                    </form>
                </div>
                <div class="login-form-footer">
                    <p id="login-footer-text">Don't have an account? <a href="<%= request.getContextPath() %>/register">Sign up</a></p>
                </div>
            </div>
        </div>
    </div>
    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script src="<%= request.getContextPath() %>/js/login.js"></script>
</body>
</html>