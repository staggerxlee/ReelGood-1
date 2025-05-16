package com.reelgood.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DbConfig {
    private static final Properties properties = new Properties();
    
    static {
        try (InputStream input = DbConfig.class.getClassLoader().getResourceAsStream("resources/db.properties")) {
            if (input == null) {
                throw new RuntimeException("Unable to find db.properties in resources directory");
            }
            properties.load(input);
            System.out.println("Database properties loaded successfully:");
            System.out.println("URL: " + properties.getProperty("db.url"));
            System.out.println("Username: " + properties.getProperty("db.username"));
            System.out.println("Password: " + (properties.getProperty("db.password").isEmpty() ? "[empty]" : "[set]"));
        } catch (IOException e) {
            throw new RuntimeException("Error loading database properties", e);
        }
    }
    
    public static Connection getDbConnection() throws SQLException {
        try {
            Class.forName(properties.getProperty("db.driver"));
            System.out.println("Attempting to connect to database...");
            Connection conn = DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.username"),
                properties.getProperty("db.password")
            );
            System.out.println("Database connection successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Failed to connect to database: " + e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("MySQL JDBC driver not found. Please add it to your project dependencies.", e);
        }
    }
}