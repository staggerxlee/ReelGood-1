package com.reelgood.model;

import com.reelgood.config.DbConfig;
import java.sql.Date;
import java.sql.Blob;
import java.io.InputStream;
import java.sql.SQLException;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;

public class MovieModel {
    private int id;
    private String title;
    private Date releaseDate;
    private String duration;
    private String genre;
    private String language;
    private Integer rating;
    private Blob image;
    private String status;
    private String description;
    private String cast;
    private String director;
    

    public void setImage(InputStream image) {
        try {
            // Read all bytes from the input stream
            byte[] imageBytes = image.readAllBytes();
            
            // Create a Blob from the bytes using the connection
            try (Connection conn = DbConfig.getDbConnection()) {
                this.image = conn.createBlob();
                try (OutputStream out = this.image.setBinaryStream(1)) {
                    out.write(imageBytes);
                }
            }
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Error reading image data: " + e.getMessage(), e);
        }
    }

    public MovieModel() {}

    public MovieModel(int id, String title, Date releaseDate, String duration, String genre, String language, Integer rating, Blob image) {
        this.id = id;
        this.title = title;
        this.releaseDate = releaseDate;
        this.duration = duration;
        this.genre = genre;
        this.language = language;
        this.rating = rating;
        this.image = image;
        this.status = "Now Showing"; // Default status
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Date getReleaseDate() { return releaseDate; }
    public void setReleaseDate(Date releaseDate) { this.releaseDate = releaseDate; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public Blob getImage() { return image; }
    public void setImage(Blob image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCast() { return cast; }
    public void setCast(String cast) { this.cast = cast; }

    public String getDirector() { return director; }
    public void setDirector(String director) { this.director = director; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isNowShowing() {
        return "Now Showing".equals(status);
    }

    public boolean isComingSoon() {
        return "Coming Soon".equals(status);
    }
} 