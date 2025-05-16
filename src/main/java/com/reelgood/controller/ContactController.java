package com.reelgood.controller;

import com.reelgood.model.ContactMessageModel;
import com.reelgood.model.UserModel;
import com.reelgood.service.ContactMessageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/contact")
public class ContactController extends HttpServlet {
    private final ContactMessageService contactMessageService = new ContactMessageService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/user/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        String email = request.getParameter("email");
        String message = request.getParameter("message");
        HttpSession session = request.getSession(false);
        Integer userId = null;
        if (session != null && session.getAttribute("user") != null) {
            UserModel user = (UserModel) session.getAttribute("user");
            userId = user.getUserID();
        }
        boolean success = false;
        String error = null;
        if (email == null || email.isEmpty() || message == null || message.isEmpty()) {
            error = "Email and message are required.";
        } else {
            ContactMessageModel contactMessage = new ContactMessageModel(userId, email, message);
            try {
                success = contactMessageService.saveContactMessage(contactMessage);
            } catch (Exception e) {
                error = "Failed to send message. Please try again.";
            }
        }
        if (success) {
            request.setAttribute("success", "Thank you for contacting us! We'll get back to you soon.");
        } else if (error != null) {
            request.setAttribute("error", error);
        }
        request.getRequestDispatcher("/WEB-INF/pages/user/contact.jsp").forward(request, response);
    }
} 