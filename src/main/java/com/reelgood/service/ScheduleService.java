package com.reelgood.service;

import com.reelgood.config.DbConfig;
import com.reelgood.model.ScheduleModel;
import com.reelgood.model.TheaterRankingModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleService {

    public List<ScheduleModel> getAllSchedules() throws SQLException {
        List<ScheduleModel> schedules = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT s.*, m.MovieTitle FROM movie_theater_schedule s " +
                         "JOIN movie m ON s.MovieID = m.MovieID " +
                         "ORDER BY FIELD(TRIM(s.ShowDay), 'Today', 'Tomorrow', 'Day After'), s.ShowTime";
            
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                
                while (rs.next()) {
                    ScheduleModel schedule = mapResultSetToSchedule(rs);
                    schedule.setMovieTitle(rs.getString("MovieTitle"));
                    schedules.add(schedule);
                }
            }
        }
        
        return schedules;
    }
    
    public List<ScheduleModel> getSchedulesByMovieId(int movieId) throws SQLException {
        List<ScheduleModel> schedules = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT s.*, m.MovieTitle FROM movie_theater_schedule s " +
                         "JOIN movie m ON s.MovieID = m.MovieID " +
                         "WHERE s.MovieID = ? " +
                         "ORDER BY FIELD(UPPER(TRIM(s.ShowDay)), 'TODAY', 'TOMORROW', 'DAY AFTER'), s.ShowTime";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, movieId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        ScheduleModel schedule = mapResultSetToSchedule(rs);
                        schedule.setMovieTitle(rs.getString("MovieTitle"));
                        schedules.add(schedule);
                    }
                }
            }
        }
        
        return schedules;
    }
    
    public ScheduleModel getScheduleById(int scheduleId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT s.*, m.MovieTitle FROM movie_theater_schedule s " +
                         "JOIN movie m ON s.MovieID = m.MovieID " +
                         "WHERE s.ScheduleID = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, scheduleId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        ScheduleModel schedule = mapResultSetToSchedule(rs);
                        schedule.setMovieTitle(rs.getString("MovieTitle"));
                        return schedule;
                    }
                }
            }
        }
        
        return null;
    }
    
    public void addSchedule(ScheduleModel schedule) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "INSERT INTO movie_theater_schedule (MovieID, TheaterLocation, ShowDay, ShowTime, " +
                         "PricePerSeat, HallNumber, LanguageFormat) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, schedule.getMovieId());
                stmt.setString(2, schedule.getTheaterLocation());
                stmt.setString(3, schedule.getShowDay());
                stmt.setTime(4, schedule.getShowTime());
                stmt.setBigDecimal(5, schedule.getPricePerSeat());
                stmt.setString(6, schedule.getHallNumber());
                stmt.setString(7, schedule.getLanguageFormat());
                
                int affectedRows = stmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating schedule failed, no rows affected.");
                }
                
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        schedule.setScheduleId(generatedKeys.getInt(1));
                    } else {
                        throw new SQLException("Creating schedule failed, no ID obtained.");
                    }
                }
            }
        }
    }
    
    public void updateSchedule(ScheduleModel schedule) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "UPDATE movie_theater_schedule SET MovieID = ?, TheaterLocation = ?, " +
                         "ShowDay = ?, ShowTime = ?, PricePerSeat = ?, HallNumber = ?, " +
                         "LanguageFormat = ? WHERE ScheduleID = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, schedule.getMovieId());
                stmt.setString(2, schedule.getTheaterLocation());
                stmt.setString(3, schedule.getShowDay());
                stmt.setTime(4, schedule.getShowTime());
                stmt.setBigDecimal(5, schedule.getPricePerSeat());
                stmt.setString(6, schedule.getHallNumber());
                stmt.setString(7, schedule.getLanguageFormat());
                stmt.setInt(8, schedule.getScheduleId());
                
                int affectedRows = stmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Updating schedule failed, no rows affected.");
                }
            }
        }
    }
    
    public void deleteSchedule(int scheduleId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "DELETE FROM movie_theater_schedule WHERE ScheduleID = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, scheduleId);
                stmt.executeUpdate();
            }
        }
    }
    
    private ScheduleModel mapResultSetToSchedule(ResultSet rs) throws SQLException {
        ScheduleModel schedule = new ScheduleModel();
        schedule.setScheduleId(rs.getInt("ScheduleID"));
        schedule.setMovieId(rs.getInt("MovieID"));
        schedule.setTheaterLocation(rs.getString("TheaterLocation"));
        schedule.setShowDay(rs.getString("ShowDay"));
        schedule.setShowTime(rs.getTime("ShowTime"));
        schedule.setPricePerSeat(rs.getBigDecimal("PricePerSeat"));
        schedule.setHallNumber(rs.getString("HallNumber"));
        schedule.setLanguageFormat(rs.getString("LanguageFormat"));
        schedule.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return schedule;
    }
    
    public List<ScheduleModel> getSchedulesForMovieDetailsByDay(int movieId, String showDay) throws SQLException {
        List<ScheduleModel> schedules = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT s.*, m.MovieTitle FROM movie_theater_schedule s " +
                         "JOIN movie m ON s.MovieID = m.MovieID " +
                         "WHERE s.MovieID = ? AND TRIM(s.ShowDay) = ? " +
                         "ORDER BY s.ShowTime";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, movieId);
                stmt.setString(2, showDay.trim());
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        ScheduleModel schedule = mapResultSetToSchedule(rs);
                        schedule.setMovieTitle(rs.getString("MovieTitle"));
                        schedules.add(schedule);
                    }
                }
            }
        }
        
        return schedules;
    }
    
    public List<TheaterRankingModel> getTopTheaters(int limit) throws SQLException {
        List<TheaterRankingModel> theaters = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT TheaterLocation, COUNT(*) as total_shows " +
                        "FROM movie_theater_schedule " +
                        "GROUP BY TheaterLocation " +
                        "ORDER BY total_shows DESC " +
                        "LIMIT ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, limit);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        TheaterRankingModel theater = new TheaterRankingModel(
                            rs.getString("TheaterLocation"),
                            rs.getInt("total_shows")
                        );
                        theaters.add(theater);
                    }
                }
            }
        }
        
        return theaters;
    }
    
    // Debug method to log raw database content
    public void debugShowSchedulesForMovie(int movieId) {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT * FROM movie_theater_schedule WHERE MovieID = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, movieId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    System.out.println("DEBUG - Raw database content for movie ID " + movieId + ":");
                    int count = 0;
                    
                    while (rs.next()) {
                        count++;
                        System.out.println("  Schedule #" + count + ":");
                        System.out.println("    ScheduleID: " + rs.getInt("ScheduleID"));
                        System.out.println("    MovieID: " + rs.getInt("MovieID"));
                        System.out.println("    TheaterLocation: " + rs.getString("TheaterLocation"));
                        System.out.println("    ShowDay: '" + rs.getString("ShowDay") + "' (length=" + rs.getString("ShowDay").length() + ")");
                        System.out.println("    ShowDay bytes: " + bytesToHex(rs.getString("ShowDay").getBytes()));
                        System.out.println("    ShowTime: " + rs.getTime("ShowTime"));
                        System.out.println("    PricePerSeat: " + rs.getBigDecimal("PricePerSeat"));
                        System.out.println("    HallNumber: " + rs.getString("HallNumber"));
                        System.out.println("    LanguageFormat: " + rs.getString("LanguageFormat"));
                    }
                    
                    if (count == 0) {
                        System.out.println("  No schedules found.");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in debugShowSchedulesForMovie: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public boolean hasBookingsForSchedule(int scheduleId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT COUNT(*) FROM bookings WHERE ScheduleID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, scheduleId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        }
        return false;
    }

    public void deleteBookingsForSchedule(int scheduleId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "DELETE FROM bookings WHERE ScheduleID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, scheduleId);
                stmt.executeUpdate();
            }
        }
    }
} 