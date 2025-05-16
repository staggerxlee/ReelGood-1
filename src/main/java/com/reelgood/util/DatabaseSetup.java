package com.reelgood.util;

import com.reelgood.config.DbConfig;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Utility class for database setup and migrations.
 */
public class DatabaseSetup {
    
    /**
     * Executes the SQL script to update the bookings table.
     */
    public static void updateBookingsTable() {
        System.out.println("Updating bookings table structure...");
        
        try {
            // Read the SQL script
            ClassLoader classLoader = DatabaseSetup.class.getClassLoader();
            InputStream inputStream = classLoader.getResourceAsStream("update_bookings_table.sql");
            
            if (inputStream == null) {
                System.err.println("Error: Could not find update_bookings_table.sql");
                return;
            }
            
            String sql = new BufferedReader(new InputStreamReader(inputStream))
                    .lines().collect(Collectors.joining("\n"));
            
            // Split the script into individual statements
            String[] statements = sql.split(";");
            
            // Execute each statement
            try (Connection conn = DbConfig.getDbConnection()) {
                for (String statement : statements) {
                    statement = statement.trim();
                    
                    // Skip empty statements and comments
                    if (statement.isEmpty() || statement.startsWith("--") || statement.startsWith("/*")) {
                        continue;
                    }
                    
                    System.out.println("Executing SQL: " + statement);
                    
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute(statement);
                    } catch (SQLException e) {
                        System.err.println("Error executing statement: " + statement);
                        System.err.println("SQLException: " + e.getMessage());
                        // Continue with the next statement
                    }
                }
                
                System.out.println("Bookings table updated successfully.");
                
                // Print the current table structure
                System.out.println("\nCurrent bookings table structure:");
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("DESCRIBE bookings")) {
                    
                    while (rs.next()) {
                        String field = rs.getString("Field");
                        String type = rs.getString("Type");
                        String nullable = rs.getString("Null");
                        String key = rs.getString("Key");
                        String defaultValue = rs.getString("Default");
                        
                        System.out.println(field + " | " + type + " | " + nullable + " | " + key + " | " + defaultValue);
                    }
                }
                
            }
        } catch (Exception e) {
            System.err.println("Error updating bookings table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Checks if a table exists in the database.
     */
    public static boolean tableExists(String tableName) throws SQLException {
        try (Connection conn = DbConfig.getDbConnection()) {
            ResultSet tables = conn.getMetaData().getTables(null, null, tableName, null);
            return tables.next();
        }
    }
    
    /**
     * Gets the list of columns for a table.
     */
    public static List<String> getTableColumns(String tableName) throws SQLException {
        List<String> columns = new ArrayList<>();
        
        try (Connection conn = DbConfig.getDbConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("DESCRIBE " + tableName)) {
            
            while (rs.next()) {
                columns.add(rs.getString("Field"));
            }
        }
        
        return columns;
    }
    
    /**
     * Adds a column to a table if it doesn't exist.
     */
    public static void addColumnIfNotExists(String tableName, String columnName, String columnDefinition) throws SQLException {
        List<String> columns = getTableColumns(tableName);
        
        if (!columns.contains(columnName)) {
            try (Connection conn = DbConfig.getDbConnection();
                 Statement stmt = conn.createStatement()) {
                
                String sql = "ALTER TABLE " + tableName + " ADD COLUMN " + columnName + " " + columnDefinition;
                stmt.execute(sql);
                
                System.out.println("Added column " + columnName + " to table " + tableName);
            }
        }
    }
} 