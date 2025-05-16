package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.model.ScheduleModel;
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
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/user/movie-details")
public class MovieDetailsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final MovieService movieService = new MovieService();
    private final ScheduleService scheduleService = new ScheduleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG - MovieDetailsController.doGet() - ENTRY");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG - MovieDetailsController - User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Debug: Print all request parameters
        System.out.println("DEBUG - MovieDetailsController - Request Parameters:");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            System.out.println("DEBUG - MovieDetailsController - " + paramName + " = " + request.getParameter(paramName));
        }
        
        // Get movieId from request parameters
        String movieIdParam = request.getParameter("movieId");
        if (movieIdParam == null || movieIdParam.isEmpty()) {
            // For backward compatibility, also check for "id" parameter
            movieIdParam = request.getParameter("id");
            System.out.println("DEBUG - MovieDetailsController - Falling back to 'id' parameter: " + movieIdParam);
        }
        
        System.out.println("DEBUG - MovieDetailsController - movieIdParam: " + movieIdParam);
        
        try {
            if (movieIdParam != null && !movieIdParam.isEmpty()) {
                int movieId = Integer.parseInt(movieIdParam);
                System.out.println("DEBUG - MovieDetailsController - parsed movieId: " + movieId);
                
                // Get movie details from the service
                MovieModel movie = movieService.getMovieById(movieId);
                System.out.println("DEBUG - MovieDetailsController - movie: " + (movie != null ? movie.getTitle() : "null"));
                
                if (movie != null) {
                    // Set movie as request attribute
                    request.setAttribute("movie", movie);
                    
                    // Get schedules for this movie
                    try {
                        // Debug raw database content
                        scheduleService.debugShowSchedulesForMovie(movieId);
                        
                        // Get all schedules for the movie
                        List<ScheduleModel> allSchedules = scheduleService.getSchedulesByMovieId(movieId);
                        System.out.println("DEBUG - All schedules for movie ID " + movieId + ": " + allSchedules.size());
                        
                        // Get schedules by day
                        List<ScheduleModel> todaySchedules = scheduleService.getSchedulesForMovieDetailsByDay(movieId, "Today");
                        System.out.println("DEBUG - Searched for 'Today' schedules, found: " + todaySchedules.size());
                        
                        List<ScheduleModel> tomorrowSchedules = scheduleService.getSchedulesForMovieDetailsByDay(movieId, "Tomorrow");
                        System.out.println("DEBUG - Searched for 'Tomorrow' schedules, found: " + tomorrowSchedules.size());
                        for(ScheduleModel schedule : tomorrowSchedules) {
                            System.out.println("DEBUG - Tomorrow schedule: ID=" + schedule.getScheduleId() + 
                                             ", MovieID=" + schedule.getMovieId() + 
                                             ", Theater=" + schedule.getTheaterLocation() + 
                                             ", Time=" + schedule.getShowTime());
                        }
                        
                        List<ScheduleModel> dayAfterSchedules = scheduleService.getSchedulesForMovieDetailsByDay(movieId, "Day After");
                        System.out.println("DEBUG - Searched for 'Day After' schedules, found: " + dayAfterSchedules.size());
                        for(ScheduleModel schedule : dayAfterSchedules) {
                            System.out.println("DEBUG - Day After schedule: ID=" + schedule.getScheduleId() + 
                                             ", MovieID=" + schedule.getMovieId() + 
                                             ", Theater=" + schedule.getTheaterLocation() + 
                                             ", Time=" + schedule.getShowTime());
                        }
                        
                        // Store in request attributes
                        request.setAttribute("allSchedules", allSchedules);
                        request.setAttribute("todaySchedules", todaySchedules);
                        request.setAttribute("tomorrowSchedules", tomorrowSchedules);
                        request.setAttribute("dayAfterSchedules", dayAfterSchedules);
                        
                        // Get unique theater locations for this movie
                        List<String> theaterLocations = new ArrayList<>();
                        for (ScheduleModel schedule : allSchedules) {
                            if (!theaterLocations.contains(schedule.getTheaterLocation())) {
                                theaterLocations.add(schedule.getTheaterLocation());
                            }
                        }
                        request.setAttribute("theaterLocations", theaterLocations);
                        
                    } catch (SQLException e) {
                        System.out.println("DEBUG - MovieDetailsController - Error loading schedules: " + e.getMessage());
                        e.printStackTrace();
                    }
                    
                    // Forward to the movie-details page
                    System.out.println("DEBUG - MovieDetailsController - Forwarding to movie-details.jsp");
                    request.getRequestDispatcher("/WEB-INF/pages/user/movie-details.jsp").forward(request, response);
                } else {
                    // Movie not found
                    System.out.println("DEBUG - MovieDetailsController - Movie not found");
                    request.setAttribute("error", "Movie not found");
                    request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
                }
            } else {
                // No movieId parameter
                System.out.println("DEBUG - MovieDetailsController - No movieId parameter");
                request.setAttribute("error", "Movie ID is required");
                request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Invalid movieId format
            System.out.println("DEBUG - MovieDetailsController - Invalid movieId format: " + e.getMessage());
            request.setAttribute("error", "Invalid movie ID format");
            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("DEBUG - MovieDetailsController - Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading movie details: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
        }
    }
} 