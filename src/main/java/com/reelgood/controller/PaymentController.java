package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.model.ScheduleModel;
import com.reelgood.model.UserModel;
import com.reelgood.service.MovieService;
import com.reelgood.service.ScheduleService;
import com.reelgood.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Enumeration;

@WebServlet("/user/payment")
public class PaymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final ScheduleService scheduleService = new ScheduleService();
    private final MovieService movieService = new MovieService();
    private final BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: PaymentController doGet method called");
        
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
            // Get parameters from the request
            String scheduleIdParam = request.getParameter("scheduleId");
            String selectedSeatsParam = request.getParameter("selectedSeats");
            
            if (scheduleIdParam == null || scheduleIdParam.isEmpty() ||
                selectedSeatsParam == null || selectedSeatsParam.isEmpty()) {
                request.setAttribute("error", "Missing required parameters");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdParam);
            String[] selectedSeats = selectedSeatsParam.split(",");
            int numberOfSeats = selectedSeats.length;
            
            // Get schedule details
            ScheduleModel schedule = scheduleService.getScheduleById(scheduleId);
            if (schedule == null) {
                request.setAttribute("error", "Invalid schedule");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
                return;
            }
            
            // Get movie details
            MovieModel movie = movieService.getMovieById(schedule.getMovieId());
            if (movie == null) {
                request.setAttribute("error", "Movie not found");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
                return;
            }
            
            // Calculate amounts
            BigDecimal pricePerSeat = schedule.getPricePerSeat();
            BigDecimal seatTotal = pricePerSeat.multiply(new BigDecimal(numberOfSeats));
            BigDecimal bookingFee = new BigDecimal("30.00"); // Fixed booking fee
            BigDecimal totalAmount = seatTotal.add(bookingFee);
            
            // Set attributes for the payment page
            request.setAttribute("schedule", schedule);
            request.setAttribute("movie", movie);
            request.setAttribute("selectedSeats", selectedSeatsParam);
            request.setAttribute("numberOfSeats", numberOfSeats);
            request.setAttribute("seatTotal", seatTotal);
            request.setAttribute("bookingFee", bookingFee);
            request.setAttribute("totalAmount", totalAmount);
            
            // Forward to payment page
            request.getRequestDispatcher("/WEB-INF/pages/user/payment.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: PaymentController doPost method called");
        
        // Debug: Print all request parameters
        System.out.println("DEBUG POST: Request parameters:");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            System.out.println("DEBUG POST: " + paramName + " = " + request.getParameter(paramName));
        }
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG POST: User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get form data
            String scheduleIdParam = request.getParameter("scheduleId");
            String selectedSeatsParam = request.getParameter("selectedSeats");
            String totalAmountParam = request.getParameter("totalAmount");
            String bookingFeeParam = request.getParameter("bookingFee");
            String paymentMethod = request.getParameter("paymentMethod");
            
            if (scheduleIdParam == null || selectedSeatsParam == null || 
                totalAmountParam == null || bookingFeeParam == null || 
                paymentMethod == null) {
                request.setAttribute("error", "Missing required parameters");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdParam);
            String[] selectedSeats = selectedSeatsParam.split(",");
            int numberOfSeats = selectedSeats.length;
            BigDecimal totalAmount = new BigDecimal(totalAmountParam);
            BigDecimal bookingFee = new BigDecimal(bookingFeeParam);
            
            // Get user information from session
            UserModel user = (UserModel) session.getAttribute("user");
            int userId = user.getUserID();
            
            // Create the booking
            int bookingId = bookingService.createBooking(
                userId, 
                scheduleId, 
                selectedSeatsParam, 
                numberOfSeats, 
                totalAmount, 
                bookingFee,
                "Confirmed"
            );
            
            if (bookingId > 0) {
                // Booking successful, redirect to confirmation page
                response.sendRedirect(request.getContextPath() + "/user/booking-confirmation?id=" + bookingId);
            } else {
                // Booking failed
                request.setAttribute("error", "Failed to create booking. Please try again.");
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
        }
    }
} 