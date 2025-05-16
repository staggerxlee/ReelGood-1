package com.reelgood.controller;

import com.reelgood.service.ContactMessageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/contact")
public class AdminContactController extends HttpServlet {
    private final ContactMessageService contactMessageService = new ContactMessageService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"2".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    contactMessageService.deleteContactMessageById(id);
                } catch (Exception e) {
                    // Optionally log error
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/support");
    }
} 