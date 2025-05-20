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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

@WebServlet({"/user/profile", "/user/profile/photo", "/user/profile/photo/delete"})
@MultipartConfig(
    fileSizeThreshold = 2 * 1024 * 1024, // 2MB
    maxFileSize = 5 * 1024 * 1024,       // 5MB
    maxRequestSize = 6 * 1024 * 1024     // 6MB
)
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
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
        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("/user/profile/photo".equals(servletPath)) {
            handlePhotoUpload(request, response, user);
            return;
        }
        if ("/user/profile/photo/delete".equals(servletPath)) {
            handlePhotoDelete(request, response, user);
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
                response.sendRedirect(request.getContextPath() + "/user/profile?section=bookings&cancel=success");
                return;
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

    private void handlePhotoUpload(HttpServletRequest request, HttpServletResponse response, UserModel currentUser)
            throws ServletException, IOException {
        Part photoPart = request.getPart("profilePhoto");
        if (photoPart != null && photoPart.getSize() > 0) {
            String contentType = photoPart.getContentType();
            
            // Check file type
            if (contentType == null || !contentType.startsWith("image/")) {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=invalid_file_type");
                return;
            }
            
            // Check file size (limit to 5MB)
            if (photoPart.getSize() > 5 * 1024 * 1024) {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=file_too_large");
                return;
            }
            
            try {
                // Compress the image before storing
                InputStream fileContent = compressImage(photoPart.getInputStream());
                
                // Get actual size of compressed image for final validation
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
                byte[] imageBytes = baos.toByteArray();
                
                // Final size check for database compatibility (limit to 5MB for LONGBLOB column)
                if (imageBytes.length > 5 * 1024 * 1024) { // 5MB
                    response.sendRedirect(request.getContextPath() + "/user/profile?error=image_too_large");
                    return;
                }
                
                // Set the compressed image
                currentUser.setPhoto(new ByteArrayInputStream(imageBytes));
                try {
                    boolean success = userService.updateUserProfile(currentUser);
                    if (success) {
                        request.getSession().setAttribute("user", currentUser);
                        response.sendRedirect(request.getContextPath() + "/user/profile?photo=success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/user/profile?error=photo_update_failed");
                    }
                } catch (SQLException e) {
                    throw new ServletException("Error updating profile photo in database", e);
                }
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=photo_processing_failed");
                e.printStackTrace();
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user/profile?error=no_photo_selected");
        }
    }

    private void handlePhotoDelete(HttpServletRequest request, HttpServletResponse response, UserModel currentUser)
            throws ServletException, IOException {
        try {
            boolean success = userService.deleteUserPhoto(currentUser.getUserID());
            if (success) {
                currentUser.setPhoto(null);
                request.getSession().setAttribute("user", currentUser);
                response.sendRedirect(request.getContextPath() + "/user/profile?photo_deleted=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=photo_delete_failed");
            }
        } catch (SQLException e) {
            throw new ServletException("Error deleting profile photo", e);
        }
    }

    private InputStream compressImage(InputStream inputStream) throws IOException {
        BufferedImage originalImage = ImageIO.read(inputStream);
        if (originalImage == null) {
            System.out.println("ImageIO.read returned null: invalid image format");
            throw new IOException("Invalid image format");
        }

        // Convert to RGB if the image has an alpha channel (transparency)
        BufferedImage rgbImage = new BufferedImage(
            originalImage.getWidth(),
            originalImage.getHeight(),
            BufferedImage.TYPE_INT_RGB
        );
        rgbImage.createGraphics().drawImage(originalImage, 0, 0, java.awt.Color.WHITE, null);

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ImageWriter writer = ImageIO.getImageWritersByFormatName("jpg").next();
        ImageOutputStream ios = ImageIO.createImageOutputStream(outputStream);
        writer.setOutput(ios);

        ImageWriteParam param = writer.getDefaultWriteParam();
        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
        param.setCompressionQuality(0.7f);

        writer.write(null, new IIOImage(rgbImage, null, null), param);

        writer.dispose();
        ios.close();

        return new ByteArrayInputStream(outputStream.toByteArray());
    }
} 