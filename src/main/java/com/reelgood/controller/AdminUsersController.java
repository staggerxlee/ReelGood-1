package com.reelgood.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.reelgood.service.AdminService;
import com.reelgood.model.UserModel;
import java.util.List;

public class AdminUsersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("2")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AdminService adminService = new AdminService();
        List<UserModel> userList = adminService.getAllUsers();
        System.out.println("User list size: " + userList.size());
        for (UserModel user : userList) {
            System.out.println("User: " + user.getUsername() + ", Role: " + user.getRole());
        }
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/WEB-INF/pages/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("2")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("promote".equals(action)) {
            String userId = request.getParameter("userId");
            if (userId != null) {
                AdminService adminService = new AdminService();
                boolean promoted = false;
                try {
                    promoted = adminService.promoteUserToAdmin(Integer.parseInt(userId));
                } catch (NumberFormatException e) {
                    System.out.println("[DEBUG] Invalid userId for promotion: " + userId);
                }
                if (promoted) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=User promoted to admin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to promote user");
                }
                return;
            }
        }
    }
} 