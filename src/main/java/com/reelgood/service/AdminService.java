package com.reelgood.service;

import com.reelgood.model.MovieModel;
import com.reelgood.model.UserModel;
import com.reelgood.model.BookingModel;
import com.reelgood.model.TheaterRankingModel;
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
            String recentBookingsQuery = "SELECT b.*, m.MovieTitle, u.Username FROM bookings b JOIN movie_theater_schedule s ON b.ScheduleID = s.ScheduleID JOIN movie m ON s.MovieID = m.MovieID JOIN user u ON b.UserID = u.UserID ORDER BY b.CreatedAt DESC LIMIT 3";
            try (PreparedStatement stmt = conn.prepareStatement(recentBookingsQuery)) {
                ResultSet rs = stmt.executeQuery();
                List<BookingModel> recentBookings = new ArrayList<>();
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
                    booking.setUsername(rs.getString("Username"));
                    recentBookings.add(booking);
                }
                stats.setRecentBookings(recentBookings);
            }

            // Get 3 recent movies
            List<MovieModel> recentMovies = getRecentMovies();
            stats.setRecentMovies(recentMovies);

            // Get top 3 theaters
            String topTheatersQuery = "SELECT TheaterLocation, COUNT(*) as total_shows " +
                                    "FROM movie_theater_schedule " +
                                    "GROUP BY TheaterLocation " +
                                    "ORDER BY total_shows DESC " +
                                    "LIMIT 3";
            try (PreparedStatement stmt = conn.prepareStatement(topTheatersQuery)) {
                ResultSet rs = stmt.executeQuery();
                List<TheaterRankingModel> topTheaters = new ArrayList<>();
                while (rs.next()) {
                    TheaterRankingModel theater = new TheaterRankingModel(
                        rs.getString("TheaterLocation"),
                        rs.getInt("total_shows")
                    );
                    topTheaters.add(theater);
                }
                stats.setTopTheaters(topTheaters);
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
            }
            
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

    public List<MovieModel> getRecentMovies() throws SQLException {
        List<MovieModel> movies = new ArrayList<>();
        String sql = "SELECT * FROM movie ORDER BY MovieID DESC LIMIT 3";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                MovieModel movie = new MovieModel();
                movie.setId(rs.getInt("MovieID"));
                movie.setTitle(rs.getString("MovieTitle"));
                movie.setReleaseDate(rs.getDate("ReleaseDate"));
                movie.setDuration(rs.getString("Duration"));
                movie.setGenre(rs.getString("Genre"));
                movie.setLanguage(rs.getString("Language"));
                movie.setRating(rs.getInt("Rating"));
                movie.setImage(rs.getBlob("Image"));
                movie.setStatus(rs.getString("Status"));
                movie.setDescription(rs.getString("Description"));
                movie.setCast(rs.getString("Cast"));
                movie.setDirector(rs.getString("Director"));
                movies.add(movie);
            }
        }
        return movies;
    }

    public static class DashboardStats {
        private int totalUsers;
        private int totalMovies;
        private int totalBookings;
        private List<BookingModel> recentBookings = new ArrayList<>();
        private List<MovieModel> recentMovies = new ArrayList<>();
        private List<TheaterRankingModel> topTheaters = new ArrayList<>();

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

        public List<MovieModel> getRecentMovies() {
            return recentMovies;
        }

        public void setRecentMovies(List<MovieModel> recentMovies) {
            this.recentMovies = recentMovies;
        }

        public List<TheaterRankingModel> getTopTheaters() {
            return topTheaters;
        }

        public void setTopTheaters(List<TheaterRankingModel> topTheaters) {
            this.topTheaters = topTheaters;
        }
    }
} 