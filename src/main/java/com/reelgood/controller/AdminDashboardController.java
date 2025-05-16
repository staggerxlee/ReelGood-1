package com.reelgood.controller;

import com.reelgood.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminDashboardController extends HttpServlet {
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        try {
            // Get dashboard stats
            AdminService.DashboardStats stats = adminService.getDashboardStats();
            request.setAttribute("stats", stats);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp").forward(request, response);
        }
    }
} 