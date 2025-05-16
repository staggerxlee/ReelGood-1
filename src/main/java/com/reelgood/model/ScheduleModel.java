package com.reelgood.model;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;

public class ScheduleModel {
    private int scheduleId;
    private int movieId;
    private String theaterLocation;
    private String showDay;
    private Time showTime;
    private BigDecimal pricePerSeat;
    private String hallNumber;
    private String languageFormat;
    private Timestamp createdAt;
    
    // For join operations
    private String movieTitle;
    
    public ScheduleModel() {}
    
    public ScheduleModel(int scheduleId, int movieId, String theaterLocation, String showDay, 
                         Time showTime, BigDecimal pricePerSeat, String hallNumber, 
                         String languageFormat, Timestamp createdAt) {
        this.scheduleId = scheduleId;
        this.movieId = movieId;
        this.theaterLocation = theaterLocation;
        this.showDay = showDay;
        this.showTime = showTime;
        this.pricePerSeat = pricePerSeat;
        this.hallNumber = hallNumber;
        this.languageFormat = languageFormat;
        this.createdAt = createdAt;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getTheaterLocation() {
        return theaterLocation;
    }

    public void setTheaterLocation(String theaterLocation) {
        this.theaterLocation = theaterLocation;
    }

    public String getShowDay() {
        return showDay;
    }

    public void setShowDay(String showDay) {
        this.showDay = showDay;
    }

    public Time getShowTime() {
        return showTime;
    }

    public void setShowTime(Time showTime) {
        this.showTime = showTime;
    }

    public BigDecimal getPricePerSeat() {
        return pricePerSeat;
    }

    public void setPricePerSeat(BigDecimal pricePerSeat) {
        this.pricePerSeat = pricePerSeat;
    }

    public String getHallNumber() {
        return hallNumber;
    }

    public void setHallNumber(String hallNumber) {
        this.hallNumber = hallNumber;
    }

    public String getLanguageFormat() {
        return languageFormat;
    }

    public void setLanguageFormat(String languageFormat) {
        this.languageFormat = languageFormat;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getMovieTitle() {
        return movieTitle;
    }
    
    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }
    
    // Format time for display (e.g., "10:00 AM")
    public String getFormattedTime() {
        if (showTime == null) {
            return "";
        }
        
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("h:mm a");
        return sdf.format(showTime);
    }
    
    // Format price (e.g., "$12.99")
    public String getFormattedPrice() {
        if (pricePerSeat == null) {
            return "";
        }
        
        return String.format("Rs. %.2f", pricePerSeat);
    }
} 