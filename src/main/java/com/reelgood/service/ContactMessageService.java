package com.reelgood.service;

import com.reelgood.model.ContactMessageModel;
import com.reelgood.config.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

public class ContactMessageService {
    public boolean saveContactMessage(ContactMessageModel message) throws SQLException {
        String sql = "INSERT INTO contactmessage (UserID, Email, Message) VALUES (?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (message.getUserId() != null) {
                stmt.setInt(1, message.getUserId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, message.getEmail());
            stmt.setString(3, message.getMessage());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<ContactMessageModel> getAllMessages() throws SQLException {
        List<ContactMessageModel> messages = new ArrayList<>();
        String sql = "SELECT ContactMessageID, UserID, Email, Message, CreatedAt FROM contactmessage ORDER BY CreatedAt DESC";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ContactMessageModel msg = new ContactMessageModel();
                msg.setContactMessageId(rs.getInt("ContactMessageID"));
                int userId = rs.getInt("UserID");
                msg.setUserId(rs.wasNull() ? null : userId);
                msg.setEmail(rs.getString("Email"));
                msg.setMessage(rs.getString("Message"));
                msg.setCreatedAt(rs.getTimestamp("CreatedAt"));
                messages.add(msg);
            }
        }
        return messages;
    }

    public boolean deleteContactMessageById(int contactMessageId) throws SQLException {
        String sql = "DELETE FROM contactmessage WHERE ContactMessageID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, contactMessageId);
            return stmt.executeUpdate() > 0;
        }
    }
} 