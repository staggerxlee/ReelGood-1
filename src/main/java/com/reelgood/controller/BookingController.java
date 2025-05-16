package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.model.ScheduleModel;
import com.reelgood.model.UserModel;
import com.reelgood.service.MovieService;
import com.reelgood.service.ScheduleService;
import com.reelgood.service.BookingService;
import jakarta.servlet.RequestDispatcher;
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
import java.util.List;

@WebServlet("/user/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final ScheduleService scheduleService = new ScheduleService();
    private final MovieService movieService = new MovieService();
    private final BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: BookingController doGet method called");
        
        try {
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
            
            // Get scheduleId from request
            String scheduleIdParam = request.getParameter("scheduleId");
            System.out.println("DEBUG: Raw scheduleIdParam = [" + scheduleIdParam + "]");
            
            if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
                try {
                    int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                    System.out.println("DEBUG: Valid scheduleId = " + scheduleId);
                    
                    // Get schedule details
                    ScheduleModel schedule = scheduleService.getScheduleById(scheduleId);
                    System.out.println("DEBUG: schedule = " + (schedule != null ? "found" : "null"));
                    
                    if (schedule != null) {
                        // Get movie details
                        MovieModel movie = movieService.getMovieById(schedule.getMovieId());
                        System.out.println("DEBUG: movie = " + (movie != null ? movie.getTitle() : "null"));
                        
                        if (movie == null) {
                            System.out.println("ERROR: Movie not found for schedule ID: " + scheduleId);
                            request.setAttribute("error", "Movie not found for this schedule");
                            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                            return;
                        }
                        
                        // Get already booked seats for this schedule
                        List<String> bookedSeats = bookingService.getBookedSeatsForSchedule(scheduleId);
                        System.out.println("DEBUG: bookedSeats count = " + bookedSeats.size());
                        
                        // Set attributes for the view
                        request.setAttribute("schedule", schedule);
                        request.setAttribute("movie", movie);
                        request.setAttribute("bookedSeats", bookedSeats);
                        request.setAttribute("bookingFee", new BigDecimal("30.00"));
                        
                        // Forward to seat selection page
                        System.out.println("DEBUG: Forwarding to booking.jsp");
                        String path = "/WEB-INF/pages/user/booking.jsp";
                        System.out.println("DEBUG: JSP path = " + path);
                        request.getRequestDispatcher(path).forward(request, response);
                        return;
                    } else {
                        System.out.println("ERROR: Schedule not found for ID: " + scheduleId);
                        request.setAttribute("error", "Schedule not found");
                        request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("ERROR: Invalid scheduleId format: " + e.getMessage());
                    request.setAttribute("error", "Invalid schedule ID format");
                    request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                    return;
                }
            } else if (request.getParameter("movieId") != null) {
                // If only movieId is provided, we need to select a default schedule
                String movieIdParam = request.getParameter("movieId");
                System.out.println("DEBUG: movieIdParam = " + movieIdParam);
                
                try {
                    int movieId = Integer.parseInt(movieIdParam);
                    // Get the first available schedule for this movie
                    List<ScheduleModel> schedules = scheduleService.getSchedulesByMovieId(movieId);
                    System.out.println("DEBUG: Found " + schedules.size() + " schedules for movie ID " + movieId);
                    
                    if (!schedules.isEmpty()) {
                        ScheduleModel schedule = schedules.get(0);
                        System.out.println("DEBUG: Using first schedule: " + schedule.getScheduleId());
                        // Redirect to the same endpoint but with scheduleId instead
                        response.sendRedirect(request.getContextPath() + "/user/booking?scheduleId=" + schedule.getScheduleId());
                        return;
                    } else {
                        System.out.println("DEBUG: No schedules found for movie ID " + movieId);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid movieId format: " + movieIdParam);
                } catch (SQLException e) {
                    System.out.println("DEBUG: SQL error getting schedules: " + e.getMessage());
                }
            } else {
                System.out.println("ERROR: No scheduleId or movieId provided");
                request.setAttribute("error", "No schedule or movie ID provided");
                request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in BookingController: " + e.getMessage());
            e.printStackTrace();
            // Try to show error page
            request.setAttribute("error", "System error: " + e.getMessage());
            try {
                request.getRequestDispatcher("/WEB-INF/pages/user/error.jsp").forward(request, response);
            } catch (Exception ex) {
                // If even that fails, show plain text error
                response.setContentType("text/plain");
                response.getWriter().write("Critical error: " + e.getMessage());
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: BookingController doPost method called");
        
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
            
            System.out.println("DEBUG POST: scheduleIdParam = " + scheduleIdParam);
            System.out.println("DEBUG POST: selectedSeatsParam = " + selectedSeatsParam);
            
            if (scheduleIdParam == null || scheduleIdParam.isEmpty() || 
                selectedSeatsParam == null || selectedSeatsParam.isEmpty()) {
                System.out.println("DEBUG POST: Missing required parameters");
                request.setAttribute("error", "Missing required parameters");
                request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                return;
            }
            
            // Redirect to payment page
            response.sendRedirect(request.getContextPath() + "/user/payment?scheduleId=" + scheduleIdParam + 
                                 "&selectedSeats=" + selectedSeatsParam);
            
        } catch (NumberFormatException e) {
            System.out.println("DEBUG POST: NumberFormatException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Invalid data format");
            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("DEBUG POST: Unexpected Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
        }
    }
} 