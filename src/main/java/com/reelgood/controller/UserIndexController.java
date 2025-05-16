package com.reelgood.controller;

import com.reelgood.service.MovieService;
import com.reelgood.model.MovieModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class UserIndexController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MovieService movieService = new MovieService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get all movies
            List<MovieModel> allMovies = movieService.getAllMovies();
            
            // Separate movies into now showing and coming soon
            List<MovieModel> nowShowingMovies = new ArrayList<>();
            List<MovieModel> comingSoonMovies = new ArrayList<>();
            
            for (MovieModel movie : allMovies) {
                if ("Now Showing".equals(movie.getStatus())) {
                    nowShowingMovies.add(movie);
                } else if ("Coming Soon".equals(movie.getStatus())) {
                    comingSoonMovies.add(movie);
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("nowShowingMovies", nowShowingMovies);
            request.setAttribute("comingSoonMovies", comingSoonMovies);
            
            // Forward to index page
            request.getRequestDispatcher("/WEB-INF/pages/user/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading movies: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
        }
    }
} 