package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.model.ScheduleModel;
import com.reelgood.service.MovieService;
import com.reelgood.service.ScheduleService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.List;

public class MovieScheduleController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ScheduleService scheduleService = new ScheduleService();
    private final MovieService movieService = new MovieService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("2")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            // Display schedules list by default
            try {
                List<ScheduleModel> schedules = scheduleService.getAllSchedules();
                request.setAttribute("schedules", schedules);
            } catch (SQLException e) {
                request.setAttribute("error", "Error loading schedules: " + e.getMessage());
            }
            
            String path = "/WEB-INF/pages/admin/schedules.jsp";
            RequestDispatcher dispatcher = request.getRequestDispatcher(path);
            dispatcher.forward(request, response);
            return;
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSchedule(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/schedules");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !session.getAttribute("role").equals("2")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/schedules");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addSchedule(request, response);
                    break;
                case "update":
                    updateSchedule(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/schedules");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/schedules.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<MovieModel> movies = movieService.getAllMovies();
            request.setAttribute("movies", movies);
            request.setAttribute("showAddModal", true);
            
            List<ScheduleModel> schedules = scheduleService.getAllSchedules();
            request.setAttribute("schedules", schedules);

            String path = "/WEB-INF/pages/admin/schedules.jsp";
            RequestDispatcher dispatcher = request.getRequestDispatcher(path);
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/schedules.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("id");
        if (scheduleIdStr != null) {
            try {
                int scheduleId = Integer.parseInt(scheduleIdStr);
                ScheduleModel schedule = scheduleService.getScheduleById(scheduleId);
                request.setAttribute("editSchedule", schedule);
                request.setAttribute("showEditModal", true);

                List<MovieModel> movies = movieService.getAllMovies();
                request.setAttribute("movies", movies);
                
                List<ScheduleModel> schedules = scheduleService.getAllSchedules();
                request.setAttribute("schedules", schedules);

                String path = "/WEB-INF/pages/admin/schedules.jsp";
                RequestDispatcher dispatcher = request.getRequestDispatcher(path);
                dispatcher.forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Error loading schedule for edit: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/pages/admin/schedules.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/schedules");
        }
    }

    private void addSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        try {
            // Parse and validate form inputs
            String movieIdStr = request.getParameter("movieId");
            String theaterLocation = request.getParameter("theaterLocation");
            String showDay = request.getParameter("showDay");
            String showTimeStr = request.getParameter("showTime");
            String priceStr = request.getParameter("pricePerSeat");
            String hallNumber = request.getParameter("hallNumber");
            String languageFormat = request.getParameter("languageFormat");

            if (movieIdStr == null || movieIdStr.trim().isEmpty() ||
                theaterLocation == null || theaterLocation.trim().isEmpty() ||
                showDay == null || showDay.trim().isEmpty() ||
                showTimeStr == null || showTimeStr.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled");
                showAddForm(request, response);
                return;
            }

            int movieId = Integer.parseInt(movieIdStr);
            Time showTime = Time.valueOf(showTimeStr + ":00"); // Add seconds if they're not included
            BigDecimal pricePerSeat = new BigDecimal(priceStr);

            // Create and save the schedule
            ScheduleModel schedule = new ScheduleModel();
            schedule.setMovieId(movieId);
            schedule.setTheaterLocation(theaterLocation.trim());
            schedule.setShowDay(showDay.trim());
            schedule.setShowTime(showTime);
            schedule.setPricePerSeat(pricePerSeat);
            schedule.setHallNumber(hallNumber != null ? hallNumber.trim() : null);
            schedule.setLanguageFormat(languageFormat != null ? languageFormat.trim() : null);

            scheduleService.addSchedule(schedule);
            response.sendRedirect(request.getContextPath() + "/admin/schedules?success=Schedule added successfully");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            showAddForm(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error adding schedule: " + e.getMessage());
            showAddForm(request, response);
        }
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        try {
            // Parse and validate form inputs
            String scheduleIdStr = request.getParameter("scheduleId");
            String movieIdStr = request.getParameter("movieId");
            String theaterLocation = request.getParameter("theaterLocation");
            String showDay = request.getParameter("showDay");
            String showTimeStr = request.getParameter("showTime");
            String priceStr = request.getParameter("pricePerSeat");
            String hallNumber = request.getParameter("hallNumber");
            String languageFormat = request.getParameter("languageFormat");

            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty() ||
                movieIdStr == null || movieIdStr.trim().isEmpty() ||
                theaterLocation == null || theaterLocation.trim().isEmpty() ||
                showDay == null || showDay.trim().isEmpty() ||
                showTimeStr == null || showTimeStr.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled");
                showEditForm(request, response);
                return;
            }

            int scheduleId = Integer.parseInt(scheduleIdStr);
            int movieId = Integer.parseInt(movieIdStr);
            Time showTime = Time.valueOf(showTimeStr + ":00"); // Add seconds if they're not included
            BigDecimal pricePerSeat = new BigDecimal(priceStr);

            // Create and update the schedule
            ScheduleModel schedule = new ScheduleModel();
            schedule.setScheduleId(scheduleId);
            schedule.setMovieId(movieId);
            schedule.setTheaterLocation(theaterLocation.trim());
            schedule.setShowDay(showDay.trim());
            schedule.setShowTime(showTime);
            schedule.setPricePerSeat(pricePerSeat);
            schedule.setHallNumber(hallNumber != null ? hallNumber.trim() : null);
            schedule.setLanguageFormat(languageFormat != null ? languageFormat.trim() : null);

            scheduleService.updateSchedule(schedule);
            response.sendRedirect(request.getContextPath() + "/admin/schedules?success=Schedule updated successfully");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            showEditForm(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error updating schedule: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("id");
        String confirmDelete = request.getParameter("confirmDeleteBookings");
        if (scheduleIdStr != null) {
            try {
                int scheduleId = Integer.parseInt(scheduleIdStr);
                boolean hasBookings = scheduleService.hasBookingsForSchedule(scheduleId);
                if (hasBookings && (confirmDelete == null || !"true".equals(confirmDelete))) {
                    // Show warning modal
                    request.setAttribute("deleteWarning", true);
                    request.setAttribute("deleteScheduleId", scheduleId);
                    // Reload schedules for the page
                    request.setAttribute("schedules", scheduleService.getAllSchedules());
                    request.getRequestDispatcher("/WEB-INF/pages/admin/schedules.jsp").forward(request, response);
                    return;
                }
                if (hasBookings && "true".equals(confirmDelete)) {
                    scheduleService.deleteBookingsForSchedule(scheduleId);
                }
                scheduleService.deleteSchedule(scheduleId);
                response.sendRedirect(request.getContextPath() + "/admin/schedules?success=Schedule deleted successfully");
            } catch (Exception e) {
                request.setAttribute("error", "Error deleting schedule: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/pages/admin/schedules.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/schedules");
        }
    }
} 