package com.reelgood.controller;

import com.reelgood.model.BookingModel;
import com.reelgood.model.MovieModel;
import com.reelgood.model.ScheduleModel;
import com.reelgood.service.BookingService;
import com.reelgood.service.MovieService;
import com.reelgood.service.ScheduleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;

@WebServlet("/user/booking-confirmation")
public class BookingConfirmationController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final BookingService bookingService = new BookingService();
    private final MovieService movieService = new MovieService();
    private final ScheduleService scheduleService = new ScheduleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: BookingConfirmationController doGet method called");
        
        // Debug: Print all request parameters
        System.out.println("DEBUG: Request parameters:");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            System.out.println("DEBUG: " + paramName + " = " + request.getParameter(paramName));
        }
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get bookingId from request
            String bookingIdParam = request.getParameter("id");
            if (bookingIdParam == null || bookingIdParam.isEmpty()) {
                request.setAttribute("error", "Missing booking ID");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
                return;
            }
            
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // For now, just forward to a confirmation page
            // In a real implementation, you would fetch the booking details from the database
            
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("success", true);
            request.setAttribute("message", "Your booking has been confirmed. Your booking ID is: " + bookingId);
            
            request.getRequestDispatcher("/WEB-INF/pages/user/booking-confirmation.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid booking ID format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        }
    }
} 