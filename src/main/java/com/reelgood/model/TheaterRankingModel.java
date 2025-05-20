package com.reelgood.model;

public class TheaterRankingModel {
    private String location;
    private int totalShows;
    
    public TheaterRankingModel() {}
    
    public TheaterRankingModel(String location, int totalShows) {
        this.location = location;
        this.totalShows = totalShows;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public int getTotalShows() {
        return totalShows;
    }
    
    public void setTotalShows(int totalShows) {
        this.totalShows = totalShows;
    }
} 