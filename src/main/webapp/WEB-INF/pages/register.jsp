<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReelGood - Create Account</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
</head>
<body>
    <div class="container">
        <div class="login-page">
            <div class="login-container">
                <div class="login-form-container"> 
                    <div class="login-form-section active" id="signup-section">
                        <picture>
                            <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="logo" style="width: 200px;" class="center"> 
                        </picture>
                        <h2>Create Account</h2>
                        
                        <% 
                            String errorMessage = (String) request.getAttribute("error");
                            String successMessage = request.getParameter("success");
                        %>

                        <% if (errorMessage != null) { %>
                            <div class="error-message"><%= errorMessage %></div>
                        <% } %>

                        <% if (successMessage != null) { %>
                            <div class="success-message"><%= successMessage %></div>
                        <% } %>

                        <form id="signup-form" action="<%= request.getContextPath() %>/register" method="post">
                            
                            <div class="login-form-group">
                                <label for="username">Username</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-user login-icon"></i>
                                    <input type="text" id="username" name="username" required>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label for="email">Email</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-envelope login-icon"></i>
                                    <input type="email" id="email" name="email" required>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label for="phone">Phone</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-phone login-icon"></i>
                                    <input type="tel" id="phone" name="phone" required>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label for="address">Address</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-location-dot login-icon"></i>
                                    <input type="text" id="address" name="address" required>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label>Gender</label>
                                <div class="login-input-group" style="display: flex; gap: 1rem; align-items: center;">
                                    <label><input type="radio" name="gender" value="Male" required> Male</label>
                                    <label><input type="radio" name="gender" value="Female"> Female</label>
                                    <label><input type="radio" name="gender" value="Other"> Other</label>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label for="password">Password</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-lock login-icon"></i>
                                    <input type="password" id="password" name="password" required>
                                    <i class="fa-solid fa-eye login-toggle-password"></i>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <div class="login-input-group">
                                    <i class="fa-solid fa-lock login-icon"></i>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                    <i class="fa-solid fa-eye login-toggle-password"></i>
                                    <span class="login-error-message"></span>
                                </div>
                            </div>
                            
                            <div class="login-terms">
                                <input type="checkbox" id="terms" required>
                                <label for="terms">I agree to the <a href="<%= request.getContextPath() %>/privacy">Terms of Service</a> and <a href="<%= request.getContextPath() %>/privacy">Privacy Policy</a></label>
                            </div>
                            
                            <button type="submit" class="login-submit-btn">
                                <span>Create Account</span>
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                    
                    <div class="login-form-footer">
                        <p id="login-footer-text">Already have an account? <a href="<%= request.getContextPath() %>/login">Login</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script src="<%= request.getContextPath() %>/js/register.js"></script>
</body>
</html> 