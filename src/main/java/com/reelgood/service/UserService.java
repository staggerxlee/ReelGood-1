package com.reelgood.service;

import com.reelgood.model.UserModel;
import com.reelgood.config.DbConfig;
import com.reelgood.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Blob;
import java.io.InputStream;

public class UserService {
    
    // Check if email already exists
    public boolean isEmailExists(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            conn = DbConfig.getDbConnection();
            String sql = "SELECT COUNT(*) FROM user WHERE Email = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            return exists;
        } catch (SQLException e) {
            throw new RuntimeException("Error checking email existence: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Error closing resources: " + e.getMessage(), e);
            }
        }
    }
    
    // Register a new user
    public int registerUser(UserModel user) throws SQLException {
        if (isEmailExists(user.getEmail())) {
            return -1; // Email already exists
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int userId = -3; // Default error status
        
        try {
            conn = DbConfig.getDbConnection();
            String sql = "INSERT INTO user (Username, Password, Email, Phone, Address, Gender, Role) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getGender());
            stmt.setInt(7, Integer.parseInt(user.getRole())); // Role should be an integer
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    userId = rs.getInt(1);
                }
            }
            return userId;
        } catch (SQLException e) {
            throw new RuntimeException("Error registering user: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Error closing resources: " + e.getMessage(), e);
            }
        }
    }
    
    public Boolean addUser(UserModel user) throws SQLException {
        int result = registerUser(user);
        return result > 0;
    }
    
    // Login user
    public UserModel loginUser(String email, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        UserModel user = null;
        
        try {
            conn = DbConfig.getDbConnection();
            String sql = "SELECT * FROM user WHERE Email = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("Password");
                
                if (PasswordUtil.verifyPassword(password, hashedPassword)) {
                    user = new UserModel();
                    user.setUserID(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    user.setAddress(rs.getString("Address"));
                    user.setGender(rs.getString("Gender"));
                    int roleInt = rs.getInt("Role");
                    user.setRole(String.valueOf(roleInt));
                }
            }
            return user;
        } catch (SQLException e) {
            throw new RuntimeException("Error logging in: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Error closing resources: " + e.getMessage(), e);
            }
        }
    }
    
    // Validation methods
    public boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }
    
    public boolean isValidPhone(String phone) {
        return phone != null && phone.length() >= 10 && phone.matches("\\d+");
    }
    
    public boolean updateUserProfile(UserModel user) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DbConfig.getDbConnection();
            boolean updatePhoto = user.getPhoto() != null;
            String sql;
            if (updatePhoto) {
                sql = "UPDATE user SET Username=?, Email=?, Phone=?, Address=?, photo=? WHERE UserID=?";
            } else {
                sql = "UPDATE user SET Username=?, Email=?, Phone=?, Address=? WHERE UserID=?";
            }
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            if (updatePhoto) {
                stmt.setBlob(5, user.getPhoto());
                stmt.setInt(6, user.getUserID());
            } else {
                stmt.setInt(5, user.getUserID());
            }
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating user profile: " + e.getMessage(), e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Error closing resources: " + e.getMessage(), e);
            }
        }
    }

    public Blob getUserPhoto(int userId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT photo FROM user WHERE UserID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getBlob("photo");
                    }
                    return null;
                }
            }
        }
    }

    public boolean deleteUserPhoto(int userId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "UPDATE user SET photo = NULL WHERE UserID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                int affectedRows = stmt.executeUpdate();
                return affectedRows > 0;
            }
        }
    }

    public boolean deleteUserById(int userId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            // Delete all contact messages for this user
            String deleteMessagesSql = "DELETE FROM contactmessage WHERE UserID = ?";
            try (PreparedStatement msgStmt = conn.prepareStatement(deleteMessagesSql)) {
                msgStmt.setInt(1, userId);
                msgStmt.executeUpdate();
            }
            // Check for any non-cancelled bookings
            String checkSql = "SELECT COUNT(*) FROM bookings WHERE UserID = ? AND status != 'Cancelled'";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        System.out.println("[DEBUG] UserID: " + userId + ", Non-cancelled bookings: " + count);
                        if (count > 0) {
                            // There are active bookings, do not allow deletion
                            return false;
                        }
                    }
                }
            }
            // Delete all bookings (even cancelled)
            String deleteBookingsSql = "DELETE FROM bookings WHERE UserID = ?";
            try (PreparedStatement delStmt = conn.prepareStatement(deleteBookingsSql)) {
                delStmt.setInt(1, userId);
                delStmt.executeUpdate();
            }
            // Delete the user
            String deleteUserSql = "DELETE FROM user WHERE UserID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteUserSql)) {
                stmt.setInt(1, userId);
                int affectedRows = stmt.executeUpdate();
                return affectedRows > 0;
            }
        }
    }

    public boolean userExists(int userId) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            String sql = "SELECT COUNT(*) FROM user WHERE UserID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        }
        return false;
    }
}