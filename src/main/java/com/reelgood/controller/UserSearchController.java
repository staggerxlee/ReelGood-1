package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/search")
public class UserSearchController extends HttpServlet {
    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        movieService = new MovieService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        List<MovieModel> results = null;
        if (query != null && !query.trim().isEmpty()) {
            results = movieService.searchMoviesByTitle(query.trim());
        }
        request.setAttribute("movies", results);
        request.setAttribute("searchQuery", query);
        request.getRequestDispatcher("/WEB-INF/pages/user/search.jsp").forward(request, response);
    }
} 