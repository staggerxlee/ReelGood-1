package com.reelgood.controller;

import com.reelgood.model.BookingModel;
import com.reelgood.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminBookingsController extends HttpServlet {
    private BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<BookingModel> bookings = getAllBookings();
            request.setAttribute("bookings", bookings);
        } catch (SQLException e) {
            request.setAttribute("error", "Error fetching bookings: " + e.getMessage());
        }
        
        String action = request.getPathInfo();
        
        if (action != null) {
            switch (action) {
                case "/cancel":
                    cancelBooking(request, response);
                    return;
                case "/restore":
                    restoreBooking(request, response);
                    return;
                default:
                    break;
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/pages/admin/bookings.jsp").forward(request, response);
    }
    
    private List<BookingModel> getAllBookings() throws SQLException {
        // We'll add a method to fetch all bookings in the BookingService
        return bookingService.getAllBookings();
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        
        try {
            int bookingId = Integer.parseInt(idParam);
            bookingService.updateBookingStatus(bookingId, "Cancelled");
            response.sendRedirect(request.getContextPath() + "/admin/bookings?success=Booking+cancelled+successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=Invalid+booking+ID");
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=" + e.getMessage());
        }
    }
    
    private void restoreBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        
        try {
            int bookingId = Integer.parseInt(idParam);
            bookingService.updateBookingStatus(bookingId, "Confirmed");
            response.sendRedirect(request.getContextPath() + "/admin/bookings?success=Booking+restored+successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=Invalid+booking+ID");
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=" + e.getMessage());
        }
    }
} 