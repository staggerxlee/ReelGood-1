package com.reelgood.controller;

import com.reelgood.model.UserModel;
import com.reelgood.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    public RegisterController() {
        this.userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        
        System.out.println("[DEBUG] Registration input: username=" + username + ", email=" + email + ", phone=" + phone + ", address=" + address + ", gender=" + gender);
        
        String errorMessage = null;
        
        // Require all fields
        if (username == null || username.isEmpty() || 
            email == null || email.isEmpty() || 
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty() ||
            phone == null || phone.isEmpty() ||
            address == null || address.isEmpty() ||
            gender == null || gender.isEmpty()) {
            errorMessage = "All fields are required.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match";
        } else if (!userService.isValidEmail(email)) {
            errorMessage = "Invalid email format";
        } else if (!userService.isValidPhone(phone)) {
            errorMessage = "Invalid phone number";
        } else {
            // Create user model
            UserModel user = new UserModel();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setAddress(address);
            user.setGender(gender);
            user.setRole("1"); // Default role as string "1" (regular user)
            
            try {
                int userId = userService.registerUser(user);
                System.out.println("[DEBUG] registerUser returned: " + userId);
                if (userId > 0) {
                    // Registration successful
                    response.sendRedirect(request.getContextPath() + "/login?registered=true");
                    return;
                } else if (userId == -1) {
                    errorMessage = "Email already exists";
                } else {
                    errorMessage = "Registration failed";
                }
            } catch (SQLException e) {
                errorMessage = "Database error: " + e.getMessage();
                System.err.println("Registration error: " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.out.println("[DEBUG] Registration error: " + errorMessage);
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("gender", gender);
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }
}