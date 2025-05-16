package com.reelgood.service;

import com.reelgood.model.UserModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.reelgood.config.DbConfig;
import com.reelgood.util.PasswordUtil;

public class RegisterService {
    
    // Simple validation methods
    public boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }
    
    public boolean isValidPhone(String phone) {
        return phone != null && phone.length() >= 10 && phone.matches("\\d+");
    }
    
    // Check if email already exists
    public boolean isEmailExists(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            conn = DbConfig.getDbConnection();
            String sql = "SELECT COUNT(*) FROM user WHERE Email=?";
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
    
    // Add user method
    public Boolean addUser(UserModel userModel) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DbConfig.getDbConnection();
            
            // First check if email exists
            if (isEmailExists(userModel.getEmail())) {
                return false;
            }
            
            String insertQuery = "INSERT INTO user (Username, Password, Email, Phone, Address, Gender, Role) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(insertQuery);
            stmt.setString(1, userModel.getUsername());
            stmt.setString(2, PasswordUtil.hashPassword(userModel.getPassword()));
            stmt.setString(3, userModel.getEmail());
            stmt.setString(4, userModel.getPhone());
            stmt.setString(5, userModel.getAddress());
            stmt.setString(6, userModel.getGender());
            stmt.setInt(7, Integer.parseInt(userModel.getRole()));
            
            int result = stmt.executeUpdate();
            success = result > 0;
            return success;
        } catch (SQLException e) {
            throw new RuntimeException("Error during registration: " + e.getMessage(), e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Error closing resources: " + e.getMessage(), e);
            }
        }
    }
}