package com.reelgood.controller;

import com.reelgood.model.UserModel;
import com.reelgood.model.BookingModel;
import com.reelgood.service.UserService;
import com.reelgood.service.BookingService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/profile")
public class ProfileController extends HttpServlet {
    private UserService userService;
    private BookingService bookingService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
        bookingService = new BookingService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get user's bookings
            List<BookingModel> bookings = bookingService.getUserBookings(user.getUserID());
            request.setAttribute("bookings", bookings);
            
            // Forward to profile page
            request.getRequestDispatcher("/WEB-INF/pages/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            // Log the error
            e.printStackTrace();
            // Set an error message
            request.setAttribute("error", "An error occurred while retrieving your bookings. Please try again later.");
            // Forward to the profile page with error message
            request.getRequestDispatcher("/WEB-INF/pages/user/profile.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            handleUpdate(request, response, user);
        } else if ("cancel".equals(action)) {
            handleCancel(request, response, user);
        }
    }
    
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, UserModel currentUser) 
            throws ServletException, IOException {
        try {
            // Update user information
            currentUser.setUsername(request.getParameter("username"));
            currentUser.setEmail(request.getParameter("email"));
            currentUser.setPhone(request.getParameter("phone"));
            currentUser.setAddress(request.getParameter("address"));
            
            boolean success = userService.updateUserProfile(currentUser);
            
            if (success) {
                // Update session with new user data
                request.getSession().setAttribute("user", currentUser);
                response.sendRedirect(request.getContextPath() + "/user/profile?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=update_failed");
            }
        } catch (SQLException e) {
            throw new ServletException("Error updating profile", e);
        }
    }
    
    private void handleCancel(HttpServletRequest request, HttpServletResponse response, UserModel user) 
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            request.setAttribute("error", "Missing booking ID");
            doGet(request, response);
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // Verify the booking belongs to the user
            List<BookingModel> userBookings = bookingService.getUserBookings(user.getUserID());
            boolean isUserBooking = false;
            for (BookingModel booking : userBookings) {
                if (booking.getId() == bookingId) {
                    isUserBooking = true;
                    break;
                }
            }
            
            if (!isUserBooking) {
                request.setAttribute("error", "You can only cancel your own bookings");
                doGet(request, response);
                return;
            }
            
            // Cancel the booking
            boolean success = bookingService.cancelBooking(bookingId);
            
            if (success) {
                request.setAttribute("success", "Booking cancelled successfully");
            } else {
                request.setAttribute("error", "Failed to cancel booking");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid booking ID format");
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
} 