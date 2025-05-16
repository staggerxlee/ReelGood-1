package com.reelgood.model;

import java.sql.Timestamp;

public class ContactMessageModel {
    private int contactMessageId;
    private Integer userId;
    private String email;
    private String message;
    private Timestamp createdAt;

    public ContactMessageModel() {}

    public ContactMessageModel(Integer userId, String email, String message) {
        this.userId = userId;
        this.email = email;
        this.message = message;
    }

    public int getContactMessageId() { return contactMessageId; }
    public void setContactMessageId(int contactMessageId) { this.contactMessageId = contactMessageId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
} 