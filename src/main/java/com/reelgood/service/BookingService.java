package com.reelgood.service;

import com.reelgood.model.BookingModel;
import com.reelgood.config.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    
    public List<BookingModel> getUserBookings(int userId) throws SQLException {
        List<BookingModel> bookings = new ArrayList<>();
        
        String sql = "SELECT b.*, m.MovieTitle, s.ShowDay, s.ShowTime, s.TheaterLocation " +
                    "FROM bookings b " +
                    "JOIN movie_theater_schedule s ON b.ScheduleID = s.ScheduleID " +
                    "JOIN movie m ON s.MovieID = m.MovieID " +
                    "WHERE b.UserID = ? " +
                    "ORDER BY b.CreatedAt DESC";
                    
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BookingModel booking = new BookingModel();
                    booking.setId(rs.getInt("BookingID"));
                    booking.setUserId(rs.getInt("UserID"));
                    booking.setShowID(rs.getInt("ScheduleID"));
                    booking.setSeats(rs.getString("SeatNumbers"));
                    booking.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                    booking.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    booking.setBookingFee(rs.getBigDecimal("BookingFee"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    booking.setMovieTitle(rs.getString("MovieTitle"));
                    booking.setShowDate(rs.getString("ShowDay"));
                    booking.setShowTime(rs.getString("ShowTime"));
                    booking.setHallID(0); // not used
                    booking.setTheaterLocation(rs.getString("TheaterLocation"));
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    // Get all bookings for admin panel
    public List<BookingModel> getAllBookings() throws SQLException {
        List<BookingModel> bookings = new ArrayList<>();
        
        String sql = "SELECT b.*, m.MovieTitle, s.ShowDay, s.ShowTime, s.TheaterLocation, u.Username " +
                    "FROM bookings b " +
                    "JOIN movie_theater_schedule s ON b.ScheduleID = s.ScheduleID " +
                    "JOIN movie m ON s.MovieID = m.MovieID " +
                    "JOIN user u ON b.UserID = u.UserID " +
                    "ORDER BY b.CreatedAt DESC";
                    
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BookingModel booking = new BookingModel();
                    booking.setId(rs.getInt("BookingID"));
                    booking.setUserId(rs.getInt("UserID"));
                    booking.setShowID(rs.getInt("ScheduleID"));
                    booking.setSeats(rs.getString("SeatNumbers"));
                    booking.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                    booking.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    booking.setBookingFee(rs.getBigDecimal("BookingFee"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    booking.setMovieTitle(rs.getString("MovieTitle"));
                    booking.setShowDate(rs.getString("ShowDay"));
                    booking.setShowTime(rs.getString("ShowTime"));
                    booking.setUsername(rs.getString("Username"));
                    booking.setTheaterLocation(rs.getString("TheaterLocation"));
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    // Update booking status (for cancellations and restorations)
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET Status = ? WHERE BookingID = ?";
        
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating booking status failed, no rows affected.");
            }
        }
    }
    
    // First, let's create a method to get the bookings table structure
    private List<String> getBookingsTableColumns() throws SQLException {
        List<String> columns = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("DESCRIBE bookings")) {
            
            while (rs.next()) {
                String columnName = rs.getString("Field");
                columns.add(columnName);
                System.out.println("DEBUG: Found column: " + columnName);
            }
        }
        
        return columns;
    }
    
    public List<String> getBookedSeatsForSchedule(int scheduleId) throws SQLException {
        List<String> bookedSeats = new ArrayList<>();
        
        // Use the SeatNumbers column that exists in the actual table
        String sql = "SELECT SeatNumbers FROM bookings WHERE ScheduleID = ? AND Status != 'Cancelled'";
        System.out.println("DEBUG: SQL Query: " + sql);
        
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, scheduleId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String seats = rs.getString("SeatNumbers");
                    if (seats != null && !seats.isEmpty()) {
                        // Seats are stored as comma-separated values
                        String[] seatArray = seats.split(",");
                        for (String seat : seatArray) {
                            bookedSeats.add(seat.trim());
                        }
                    }
                }
            }
        }
        
        return bookedSeats;
    }
    
    public int createBooking(int userId, int scheduleId, String selectedSeats, 
                           int numberOfSeats, BigDecimal totalAmount, 
                           BigDecimal bookingFee, String status) throws SQLException {
        // Use the actual column names from the existing table
        String sql = "INSERT INTO bookings (UserID, ScheduleID, SeatNumbers, NumberOfSeats, " +
                    "TotalAmount, BookingFee, Status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
                    
        System.out.println("DEBUG: Insert SQL: " + sql);
        
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, scheduleId);
            stmt.setString(3, selectedSeats);
            stmt.setInt(4, numberOfSeats);
            stmt.setBigDecimal(5, totalAmount);
            stmt.setBigDecimal(6, bookingFee);
            stmt.setString(7, status);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating booking failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating booking failed, no ID obtained.");
                }
            }
        }
    }
    
    public boolean cancelBooking(int bookingId) throws SQLException {
        // First get the booking details
        String getBookingSql = "SELECT ScheduleID, SeatNumbers FROM bookings WHERE BookingID = ?";
        int scheduleId = 0;
        String seatNumbers = null;
        
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(getBookingSql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    scheduleId = rs.getInt("ScheduleID");
                    seatNumbers = rs.getString("SeatNumbers");
                } else {
                    return false; // Booking not found
                }
            }
        }
        
        // Update booking status to Cancelled
        String updateBookingSql = "UPDATE bookings SET Status = 'Cancelled' WHERE BookingID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(updateBookingSql)) {
            
            stmt.setInt(1, bookingId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected == 0) {
                return false; // No booking was updated
            }
        }
        
        // The seat availability is handled by the getBookedSeatsForSchedule method
        // which only returns seats from non-cancelled bookings
        return true;
    }
} 