-- Create database if not exists
CREATE DATABASE IF NOT EXISTS reelgood;
USE reelgood;

-- User Table
CREATE TABLE IF NOT EXISTS user (
                                    UserID INT PRIMARY KEY AUTO_INCREMENT,
                                    Username VARCHAR(100) NOT NULL,
                                    Password VARCHAR(255) NOT NULL,
                                    Email VARCHAR(100) NOT NULL UNIQUE,
                                    Phone VARCHAR(20),
                                    Address VARCHAR(255),
                                    Gender VARCHAR(10),
                                    Role INT NOT NULL DEFAULT 1 -- 1 = user, 2 = admin
);

-- Contact Message Table
CREATE TABLE IF NOT EXISTS contactmessage (
                                              ContactMessageID INT PRIMARY KEY AUTO_INCREMENT,
                                              UserID INT,
                                              Email VARCHAR(100) NOT NULL,
                                              Message TEXT NOT NULL,
                                              CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              FOREIGN KEY (UserID) REFERENCES user(UserID) ON DELETE SET NULL
);

-- Movie Table
CREATE TABLE IF NOT EXISTS movie (
                                     MovieID INT PRIMARY KEY AUTO_INCREMENT,
                                     MovieTitle VARCHAR(255) NOT NULL,
                                     ReleaseDate DATE,
                                     Duration VARCHAR(10),
                                     Genre VARCHAR(100),
                                     Language VARCHAR(50),
                                     Rating DECIMAL(3,1),
                                     Status VARCHAR(20),
                                     Description TEXT,
                                     Cast TEXT,
                                     Director VARCHAR(100),
                                     Image BLOB
);

-- Movie Theater Schedule Table
CREATE TABLE IF NOT EXISTS movie_theater_schedule (
                                                      ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
                                                      MovieID INT NOT NULL,
                                                      TheaterLocation VARCHAR(255) NOT NULL,
                                                      ShowDay VARCHAR(20) NOT NULL,
                                                      ShowTime TIME NOT NULL,
                                                      PricePerSeat DECIMAL(10,2) NOT NULL,
                                                      HallNumber VARCHAR(10) NOT NULL,
                                                      LanguageFormat VARCHAR(50),
                                                      FOREIGN KEY (MovieID) REFERENCES movie(MovieID)
);

-- Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
                                        BookingID INT PRIMARY KEY AUTO_INCREMENT,
                                        UserID INT NOT NULL,
                                        ScheduleID INT NOT NULL,
                                        SeatNumbers VARCHAR(100) NOT NULL,
                                        NumberOfSeats INT NOT NULL,
                                        TotalAmount DECIMAL(10,2) NOT NULL,
                                        BookingFee DECIMAL(10,2) NOT NULL,
                                        Status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
                                        CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (UserID) REFERENCES user(UserID),
                                        FOREIGN KEY (ScheduleID) REFERENCES movie_theater_schedule(ScheduleID)
); 