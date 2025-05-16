package com.reelgood.service;

import com.reelgood.model.MovieModel;
import com.reelgood.model.UserModel;
import com.reelgood.model.BookingModel;
import com.reelgood.config.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminService {
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        try (Connection conn = DbConfig.getDbConnection()) {
            // Get total users
            String userQuery = "SELECT COUNT(*) FROM user";
            try (PreparedStatement stmt = conn.prepareStatement(userQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setTotalUsers(rs.getInt(1));
                }
            }

            // Get total movies
            String movieQuery = "SELECT COUNT(*) FROM movie";
            try (PreparedStatement stmt = conn.prepareStatement(movieQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("[DEBUG] Movie count from DB: " + count);
                    stats.setTotalMovies(count);
                }
            }

            // Get total bookings
            String bookingQuery = "SELECT COUNT(*) FROM bookings";
            try (PreparedStatement stmt = conn.prepareStatement(bookingQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.setTotalBookings(rs.getInt(1));
                }
            }

            // Get recent bookings
            String recentBookingsQuery = "SELECT b.*, u.username, m.MovieTitle FROM bookings b " +
                    "JOIN users u ON b.user_id = u.id " +
                    "JOIN movie m ON b.movie_id = m.MovieID " +
                    "ORDER BY b.booking_date DESC LIMIT 5";
            try (PreparedStatement stmt = conn.prepareStatement(recentBookingsQuery)) {
                ResultSet rs = stmt.executeQuery();
                List<BookingModel> recentBookings = new ArrayList<>();
                while (rs.next()) {
                    BookingModel booking = new BookingModel();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setMovieId(rs.getInt("movie_id"));
                    booking.setBookingDate(rs.getTimestamp("booking_date"));
                    booking.setStatus(rs.getString("status"));
                    booking.setUsername(rs.getString("username"));
                    booking.setMovieTitle(rs.getString("MovieTitle"));
                    recentBookings.add(booking);
                }
                stats.setRecentBookings(recentBookings);
            }

        } catch (SQLException e) {
            System.out.println("[DEBUG] SQL Exception in getDashboardStats: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    public List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY UserID";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("[DEBUG] Executing query: " + sql);
            
            while (rs.next()) {
                UserModel user = new UserModel();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setAddress(rs.getString("Address"));
                user.setPhone(rs.getString("Phone"));
                user.setEmail(rs.getString("Email"));
                user.setGender(rs.getString("Gender"));
                user.setRole(String.valueOf(rs.getInt("Role")));
                users.add(user);
                
                System.out.println("[DEBUG] Found user: ID=" + user.getUserID() + 
                                 ", Username=" + user.getUsername() + 
                                 ", Role=" + user.getRole());
            }
            
            System.out.println("[DEBUG] Total users found: " + users.size());
            
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQL Exception in getAllUsers: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public boolean deleteUserById(int userId) {
        String sql = "DELETE FROM user WHERE UserID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int affectedRows = stmt.executeUpdate();
            System.out.println("[DEBUG] Deleted user with ID: " + userId + ", affectedRows: " + affectedRows);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQL Exception in deleteUserById: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean promoteUserToAdmin(int userId) {
        String sql = "UPDATE user SET Role = 2 WHERE UserID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQL Exception in promoteUserToAdmin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static class DashboardStats {
        private int totalUsers;
        private int totalMovies;
        private int totalBookings;
        private List<BookingModel> recentBookings = new ArrayList<>();

        public int getTotalUsers() {
            return totalUsers;
        }

        public void setTotalUsers(int totalUsers) {
            this.totalUsers = totalUsers;
        }

        public int getTotalMovies() {
            return totalMovies;
        }

        public void setTotalMovies(int totalMovies) {
            this.totalMovies = totalMovies;
        }

        public int getTotalBookings() {
            return totalBookings;
        }

        public void setTotalBookings(int totalBookings) {
            this.totalBookings = totalBookings;
        }

        public List<BookingModel> getRecentBookings() {
            return recentBookings;
        }

        public void setRecentBookings(List<BookingModel> recentBookings) {
            this.recentBookings = recentBookings;
        }
    }
} 