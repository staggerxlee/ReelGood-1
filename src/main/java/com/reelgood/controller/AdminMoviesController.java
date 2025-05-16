package com.reelgood.controller;

import com.reelgood.model.MovieModel;
import com.reelgood.service.MovieService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

public class AdminMoviesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
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
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    MovieModel editMovie = movieService.getMovieById(id);
                    request.setAttribute("editMovie", editMovie);
                    request.setAttribute("showEditModal", true);
                } catch (Exception e) {
                    request.setAttribute("error", "Error loading movie for edit: " + e.getMessage());
                }
            }
        }

        try {
            List<MovieModel> movies = movieService.getAllMovies();
            request.setAttribute("movies", movies);

            String path = "/WEB-INF/pages/admin/adminmovies.jsp";
            RequestDispatcher dispatcher = request.getRequestDispatcher(path);
            dispatcher.forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading movies: " + e.getMessage());
            String path = "/WEB-INF/pages/admin/adminmovies.jsp";
            request.getRequestDispatcher(path).forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/movies");
            return;
        }

        try {
            switch (action) {
                case "add":
                    handleAdd(request, response);
                    break;
                case "update":
                    handleUpdate(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/movies");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, ParseException {
        // Validate required parameters
        String title = request.getParameter("title");
        String releaseDateStr = request.getParameter("releaseDate");
        String duration = request.getParameter("duration");
        String genre = request.getParameter("genre");
        String language = request.getParameter("language");
        String ratingStr = request.getParameter("rating");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String cast = request.getParameter("cast");
        String director = request.getParameter("director");

        // Validate input
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Title is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if (releaseDateStr == null || releaseDateStr.trim().isEmpty()) {
            request.setAttribute("error", "Release date is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if (duration == null || duration.trim().isEmpty()) {
            request.setAttribute("error", "Duration is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if (genre == null || genre.trim().isEmpty()) {
            request.setAttribute("error", "Genre is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if (language == null || language.trim().isEmpty()) {
            request.setAttribute("error", "Language is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            request.setAttribute("error", "Status is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if ("Now Showing".equals(status) && (ratingStr == null || ratingStr.trim().isEmpty())) {
            request.setAttribute("error", "Rating is required for Now Showing movies");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        try {
            MovieModel movie = new MovieModel();
            movie.setTitle(title);
            
            // Parse date safely
            try {
                java.util.Date parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(releaseDateStr);
                movie.setReleaseDate(new Date(parsedDate.getTime()));
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD");
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                return;
            }
            
            movie.setDuration(duration);
            movie.setGenre(genre);
            movie.setLanguage(language);
            
            if ("Now Showing".equals(status) && ratingStr != null && !ratingStr.trim().isEmpty()) {
                try {
                    movie.setRating(Integer.parseInt(ratingStr));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Rating must be a number");
                    request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                    return;
                }
            } else {
                movie.setRating(null);
            }
            
            movie.setStatus(status);
            movie.setDescription(description);
            movie.setCast(cast);
            movie.setDirector(director);

            // Handle file upload with proper error checking
            try {
                Part filePart = request.getPart("poster");
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    
                    // Check file type
                    if (contentType == null || !contentType.startsWith("image/")) {
                        request.setAttribute("error", "Only image files are allowed for the poster");
                        request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                        return;
                    }
                    
                    // Check file size (limit to 2MB - more strict than before)
                    if (filePart.getSize() > 2 * 1024 * 1024) {
                        request.setAttribute("error", "Image file is too large (max 2MB)");
                        request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                        return;
                    }
                    
                    System.out.println("[DEBUG] Original poster size: " + filePart.getSize() + " bytes");
                    
                    try {
                        // Compress the image before uploading
                        InputStream fileContent = compressImage(filePart.getInputStream());
                        
                        // Get actual size of compressed image for final validation
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = fileContent.read(buffer)) != -1) {
                            baos.write(buffer, 0, bytesRead);
                        }
                        byte[] imageBytes = baos.toByteArray();
                        
                        // Final size check for database compatibility (limit to 64KB for BLOB column)
                        if (imageBytes.length > 64 * 1024) {
                            request.setAttribute("error", "Image still too large after compression. Please use a smaller image.");
                            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                            return;
                        }
                        
                        // Use the byte array for the image data
                        movie.setImage(new ByteArrayInputStream(imageBytes));
                        System.out.println("[DEBUG] Final image size after compression: " + imageBytes.length + " bytes");
                    } catch (Exception e) {
                        request.setAttribute("error", "Error processing image: " + e.getMessage());
                        e.printStackTrace();
                        request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                        return;
                    }
                } else {
                    System.out.println("[DEBUG] No poster image included");
                }
            } catch (Exception e) {
                System.out.println("[DEBUG] Error processing poster image: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Error processing poster image: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG] Adding movie: " + movie.getTitle());
            movieService.addMovie(movie);
            
            // Redirect to the movies page, not dashboard
            response.sendRedirect(request.getContextPath() + "/admin/movies?success=Movie added successfully");
            
        } catch (Exception e) {
            System.out.println("[DEBUG] Error adding movie: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error adding movie: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, ParseException {
        // Get and validate parameters
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String releaseDateStr = request.getParameter("releaseDate");
        String duration = request.getParameter("duration");
        String genre = request.getParameter("genre");
        String language = request.getParameter("language");
        String ratingStr = request.getParameter("rating");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String cast = request.getParameter("cast");
        String director = request.getParameter("director");

        System.out.println("[DEBUG] handleUpdate called with: id=" + idStr + ", title=" + title + ", releaseDate=" + releaseDateStr + ", duration=" + duration + ", genre=" + genre + ", language=" + language + ", rating=" + ratingStr + ", status=" + status);

        // Validate input
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Movie ID is required");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        if ("Now Showing".equals(status)) {
            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                request.setAttribute("error", "Rating is required for Now Showing movies");
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                return;
            }
        }

        try {
            int id = Integer.parseInt(idStr);
            MovieModel existingMovie = movieService.getMovieById(id);
            if (existingMovie == null) {
                request.setAttribute("error", "Movie with ID " + id + " does not exist");
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                return;
            }

            MovieModel movie = new MovieModel();
            movie.setId(id);
            movie.setTitle(title);
            movie.setReleaseDate(new Date(new SimpleDateFormat("yyyy-MM-dd").parse(releaseDateStr).getTime()));
            movie.setDuration(duration);
            movie.setGenre(genre);
            movie.setLanguage(language);
            if ("Now Showing".equals(status)) {
                movie.setRating(Integer.parseInt(ratingStr));
            } else {
                movie.setRating(null);
            }
            movie.setStatus(status);
            movie.setDescription(description);
            movie.setCast(cast);
            movie.setDirector(director);

            // Handle movie image
            Part filePart = request.getPart("poster");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                
                // Check file type
                if (contentType == null || !contentType.startsWith("image/")) {
                    request.setAttribute("error", "Only image files are allowed for the poster");
                    request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                    return;
                }
                
                // Check file size (limit to 2MB - more strict than before)
                if (filePart.getSize() > 2 * 1024 * 1024) {
                    request.setAttribute("error", "Image file is too large (max 2MB)");
                    request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                    return;
                }
                
                System.out.println("[DEBUG] Original poster size: " + filePart.getSize() + " bytes");
                
                try {
                    // Compress the image before uploading
                    InputStream fileContent = compressImage(filePart.getInputStream());
                    
                    // Get actual size of compressed image for final validation
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        baos.write(buffer, 0, bytesRead);
                    }
                    byte[] imageBytes = baos.toByteArray();
                    
                    // Final size check for database compatibility (limit to 64KB for BLOB column)
                    if (imageBytes.length > 64 * 1024) {
                        request.setAttribute("error", "Image still too large after compression. Please use a smaller image.");
                        request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                        return;
                    }
                    
                    // Use the byte array for the image data
                    movie.setImage(new ByteArrayInputStream(imageBytes));
                    System.out.println("[DEBUG] Final image size after compression: " + imageBytes.length + " bytes");
                } catch (Exception e) {
                    request.setAttribute("error", "Error processing image: " + e.getMessage());
                    e.printStackTrace();
                    request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                    return;
                }
            }

            System.out.println("[DEBUG] Calling movieService.updateMovie for movie ID: " + id);
            movieService.updateMovie(movie);
            System.out.println("[DEBUG] movieService.updateMovie completed for movie ID: " + id);
            response.sendRedirect(request.getContextPath() + "/admin/movies?success=Movie updated successfully");
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] NumberFormatException in handleUpdate: " + e.getMessage());
            request.setAttribute("error", "Invalid movie ID or rating value");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQLException in handleUpdate: " + e.getMessage());
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception in handleUpdate: " + e.getMessage());
            request.setAttribute("error", "Error updating movie: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Movie ID is required for deletion");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            MovieModel existingMovie = movieService.getMovieById(id);
            if (existingMovie == null) {
                request.setAttribute("error", "Movie with ID " + id + " does not exist");
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
                return;
            }

            movieService.deleteMovie(id);
            response.sendRedirect(request.getContextPath() + "/admin/movies?success=Movie deleted successfully");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid movie ID");
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting movie: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminmovies.jsp").forward(request, response);
        }
    }

    private InputStream compressImage(InputStream inputStream) throws IOException {
        // Read the input stream into a BufferedImage
        BufferedImage originalImage = ImageIO.read(inputStream);
        if (originalImage == null) {
            throw new IOException("Failed to read image file");
        }
        
        // Get original dimensions
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        
        // Calculate new dimensions - resize to max 500px width/height while maintaining aspect ratio
        int targetWidth = 500;
        int targetHeight = 500;
        
        if (originalWidth > originalHeight) {
            targetHeight = (int) (originalHeight * ((double) targetWidth / originalWidth));
        } else {
            targetWidth = (int) (originalWidth * ((double) targetHeight / originalHeight));
        }
        
        // Create a new BufferedImage with reduced size
        BufferedImage resizedImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        
        // Draw the original image on the resized image canvas
        resizedImage.createGraphics().drawImage(originalImage, 0, 0, targetWidth, targetHeight, null);
        
        // Create output stream for compressed image
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        
        // Get a JPEG writer
        ImageWriter writer = ImageIO.getImageWritersByFormatName("jpeg").next();
        
        // Setup the compression parameters
        ImageWriteParam params = writer.getDefaultWriteParam();
        if (params.canWriteCompressed()) {
            params.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            // Set the compression quality very low (0.0-1.0, where 1.0 is highest quality)
            params.setCompressionQuality(0.5f);
        }
        
        // Setup the output
        ImageOutputStream imageOutputStream = ImageIO.createImageOutputStream(outputStream);
        writer.setOutput(imageOutputStream);
        
        // Write the image with compression
        writer.write(null, new IIOImage(resizedImage, null, null), params);
        
        // Clean up
        writer.dispose();
        imageOutputStream.close();
        
        int compressedSize = outputStream.size();
        System.out.println("[DEBUG] Image compressed from " + (originalWidth * originalHeight * 3) + 
                          " bytes to " + compressedSize + " bytes");
        System.out.println("[DEBUG] Resized from " + originalWidth + "x" + originalHeight + 
                          " to " + targetWidth + "x" + targetHeight);
        System.out.println("[DEBUG] Compressed image size: " + (compressedSize / 1024) + " KB");
        
        // Return the compressed image as an InputStream
        return new ByteArrayInputStream(outputStream.toByteArray());
    }
}
