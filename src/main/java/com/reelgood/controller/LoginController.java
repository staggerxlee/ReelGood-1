package com.reelgood.controller;

import com.reelgood.model.UserModel;
import com.reelgood.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import java.util.Arrays;

@WebServlet(asyncSupported = true)
@MultipartConfig
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60;

    public LoginController() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role) || "2".equals(role)) {
                try {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp");
                    if (dispatcher == null) {
                        throw new ServletException("Could not find dispatcher for admin dashboard.jsp");
                    }
                    dispatcher.forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("[LoginController] Failed to forward to admin dashboard page: " + e.getMessage());
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not find admin dashboard JSP page");
                }
            } else {
                try {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/index.jsp");
                    if (dispatcher == null) {
                        throw new ServletException("Could not find dispatcher for index.jsp");
                    }
                    dispatcher.forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("[LoginController] Failed to forward to index page: " + e.getMessage());
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not find index JSP page");
                }
            }
            return;
        }
        try {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
            if (dispatcher == null) {
                throw new ServletException("Could not find dispatcher for login.jsp");
            }
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[LoginController] Failed to forward to login page: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not find login JSP page");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String errorMessage = null;

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Email and password are required";
        } else {
            try {
                UserModel user = userService.loginUser(email, password);
                if (user != null) {
                    // Create session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userID", user.getUserID());
                    session.setAttribute("role", user.getRole());
                    
                    // Forward to appropriate page based on role
                    if ("2".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/user/index");
                    }

                    // Set cookies
                    Cookie customSessionCookie = new Cookie("reelgood_session", session.getId());
                    customSessionCookie.setMaxAge(COOKIE_MAX_AGE);
                    customSessionCookie.setPath("/");
                    response.addCookie(customSessionCookie);

                    // Debug output
                    System.out.println("[DEBUG] LoginController: Session ID: " + session.getId());
                    System.out.println("[DEBUG] LoginController: Cookies after login: " + Arrays.toString(request.getCookies()));

                    return;
                } else {
                    errorMessage = "Invalid email or password";
                }
            } catch (SQLException e) {
                errorMessage = "Database error: " + e.getMessage();
                e.printStackTrace();
            }
        }

        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }
}