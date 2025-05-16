package com.reelgood.controller;

import com.reelgood.service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.SQLException;

public class MovieImageController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MovieService movieService = new MovieService();
    private static final int BUFFER_SIZE = 4096;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID is required");
            return;
        }

        try {
            int movieId = Integer.parseInt(idParam);
            Blob image = movieService.getMovieImage(movieId);
            
            if (image == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie image not found");
                return;
            }

            // Set content type based on image type
            String contentType = "image/jpeg"; // Default to JPEG
            response.setContentType(contentType);
            response.setContentLength((int) image.length());

            try (OutputStream out = response.getOutputStream()) {
                try (InputStream in = image.getBinaryStream()) {
                    byte[] buffer = new byte[BUFFER_SIZE];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid movie ID format");
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}