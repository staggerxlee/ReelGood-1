<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <script>
    document.addEventListener('DOMContentLoaded', function() {
    	  const passwordInput = document.getElementById('login-password');
    	  const toggleBtn = document.querySelector('.login-toggle-password');
    	  if (passwordInput && toggleBtn) {
    	    toggleBtn.addEventListener('click', function() {
    	      const isPassword = passwordInput.type === 'password';
    	      passwordInput.type = isPassword ? 'text' : 'password';
    	      this.classList.toggle('fa-eye');
    	      this.classList.toggle('fa-eye-slash');
    	    });
    	  }
    	});</script>
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <div class="login-form-container">    
                <div class="login-form-section active" id="login-section">
                    <picture>
                        <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="logo" style="width: 200px; height: auto;" class="center"> 
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
    <c:if test="${param.error == 'nouser'}">
      <div id="login-error-popup" style="position: fixed; top: 32px; left: 50%; transform: translateX(-50%); background: #2a1616; color: #ff4757; padding: 18px 36px; border-radius: 10px; box-shadow: 0 4px 24px rgba(0,0,0,0.18); font-size: 1.08rem; z-index: 9999; text-align: center;">
        <i class="fa fa-exclamation-circle" style="margin-right: 8px;"></i>
        No user found with these credentials.
      </div>
      <script>
        setTimeout(function() {
          var popup = document.getElementById('login-error-popup');
          if (popup) popup.style.display = 'none';
        }, 3500);
      </script>
    </c:if>
    <c:if test="${param.account_deleted == '1'}">
      <div id="login-success-popup" style="position: fixed; top: 32px; left: 50%; transform: translateX(-50%); background: #231818; color: #4BB543; padding: 18px 36px; border-radius: 10px; box-shadow: 0 4px 24px rgba(0,0,0,0.18); font-size: 1.08rem; z-index: 9999; text-align: center;">
        <i class="fa fa-check-circle" style="margin-right: 8px;"></i>
        Your account has been deleted successfully.
      </div>
      <script>
        setTimeout(function() {
          var popup = document.getElementById('login-success-popup');
          if (popup) popup.style.display = 'none';
        }, 3500);
      </script>
    </c:if>
    <c:if test="${param.registered == 'true'}">
      <div id="login-success-popup" style="position: fixed; top: 32px; left: 50%; transform: translateX(-50%); background: #231818; color: #4BB543; padding: 18px 36px; border-radius: 10px; box-shadow: 0 4px 24px rgba(0,0,0,0.18); font-size: 1.08rem; z-index: 9999; text-align: center;">
        <i class="fa fa-check-circle" style="margin-right: 8px;"></i>
        Account created successfully! Please log in.
      </div>
      <script>
        setTimeout(function() {
          var popup = document.getElementById('login-success-popup');
          if (popup) popup.style.display = 'none';
        }, 3500);
      </script>
    </c:if>
    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script src="<%= request.getContextPath() %>/js/login.js"></script>
</body>
</html>