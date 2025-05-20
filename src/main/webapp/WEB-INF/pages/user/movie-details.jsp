<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="user-navbar.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReelGood - ${movie.title}</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">

  <style>
    /* Additional styles for the schedule section */
    .theater-selector {
      margin-bottom: 15px;
    }
    
    .theater-selector select {
      padding: 8px 12px;
      border-radius: 4px;
      border: 1px solid #ddd;
      font-size: 14px;
      width: 250px;
    }
    
    .no-schedules {
      color: #666;
      font-style: italic;
      padding: 15px 0;
    }
    
    .book-btn {
      display: inline-block;
      background-color: #ff4757;
      color: white;
      padding: 12px 25px;
      border-radius: 5px;
      text-decoration: none;
      font-weight: 600;
      margin-top: 20px;
      transition: background-color 0.3s;
    }
    
    .book-btn:hover {
      background-color: #ff6b81;
    }
    
    .showtime-slots .time-slot {
      position: relative;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 10px;
    }
    
    .time-slot span.price {
      display: block;
      font-size: 12px;
      color: #666;
      margin-top: 3px;
    }
    
    .time-slot span.format {
      position: absolute;
      top: -6px;
      right: -6px;
      background: #333;
      color: white;
      font-size: 10px;
      padding: 2px 4px;
      border-radius: 3px;
    }
    
    .time-slot span.hall {
      font-size: 11px;
      color: #777;
      display: block;
      margin-top: 2px;
    }
    
    .time-slot.selectable {
      cursor: pointer;
      transition: all 0.2s ease;
    }
    
    .time-slot.selectable:hover {
      background-color: #f5f5f5;
      border-color: #ff4757;
    }
    
    .time-slot.selected {
      background-color: #ff4757;
      color: white;
      border-color: #ff4757;
    }
    
    .time-slot.selected span {
      color: white !important;
    }
  </style>
</head>
<body class="movie-details-page">
  <div class="container">
    <a href="<%= request.getContextPath() %>/user/index" class="back-link">
      <i class="fa-solid fa-arrow-left"></i> Back to movies
    </a>
    
    <!-- Debug information -->
    <% if (request.getParameter("debug") != null) { %>
    <div style="background: #f5f5f5; padding: 10px; margin: 10px 0; border: 1px solid #ddd;">
      <h4>Debug Info - Movie ID: ${movie.id}</h4>
      <p>All Schedules: ${allSchedules.size()}</p>
      <p>Today Schedules: ${todaySchedules.size()}</p>
      <p>Tomorrow Schedules: ${tomorrowSchedules.size()}</p>
      <p>Day After Schedules: ${dayAfterSchedules.size()}</p>
      
      <h5>Tomorrow Schedules:</h5>
      <c:forEach var="schedule" items="${tomorrowSchedules}">
        <p>ID: ${schedule.scheduleId}, Theater: ${schedule.theaterLocation}, Time: ${schedule.formattedTime}</p>
      </c:forEach>
      
      <h5>Day After Schedules:</h5>
      <c:forEach var="schedule" items="${dayAfterSchedules}">
        <p>ID: ${schedule.scheduleId}, Theater: ${schedule.theaterLocation}, Time: ${schedule.formattedTime}</p>
      </c:forEach>
    </div>
    <% } %>
    
    <div class="movie-details">
      <div class="movie-poster-large">
        <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}">
        <div class="content-rating-badge">PG</div>
      </div>
      
      <div class="movie-info-detailed">
        <h1>${movie.title}</h1>
        
        <div class="movie-meta">
          <span>${movie.duration} min</span>
          <span class="separator">•</span>
          <span>${movie.genre}</span>
          <span class="separator">•</span>
          <span>${movie.language}</span>
        </div>
        
        <div class="movie-rating-score">
          <i class="fa-solid fa-star star-icon"></i>
          <span>${movie.rating}/10</span>
        </div>
        
        <div class="movie-description">
          <p class="text-muted">
            <c:choose>
              <c:when test="${not empty movie.description}">${movie.description}</c:when>
              <c:otherwise>No description available for this movie.</c:otherwise>
            </c:choose>
          </p>
        </div>
        
        <div class="movie-cast">
          <h3 class="section-title">Cast</h3>
          <p class="text-muted">
            <c:choose>
              <c:when test="${not empty movie.cast}">${movie.cast}</c:when>
              <c:otherwise>Cast information not available.</c:otherwise>
            </c:choose>
          </p>
        </div>
        
        <div class="movie-director">
          <h3 class="section-title">Director</h3>
          <p class="text-muted">
            <c:choose>
              <c:when test="${not empty movie.director}">${movie.director}</c:when>
              <c:otherwise>Director information not available.</c:otherwise>
            </c:choose>
          </p>
        </div>
        
        <div class="showtime-section">
          <h3 class="section-title">Showtimes</h3>
          
          <c:if test="${not empty theaterLocations}">
            <div class="theater-selector">
              <select id="theaterSelect">
                <option value="all">All theaters</option>
                <c:forEach var="theater" items="${theaterLocations}">
                  <option value="${theater}">${theater}</option>
                </c:forEach>
              </select>
            </div>
          </c:if>
          
          <div class="date-tabs">
            <button class="date-tab active" data-day="today">Today</button>
            <button class="date-tab" data-day="tomorrow">Tomorrow</button>
            <button class="date-tab" data-day="dayafter">Day After</button>
          </div>
          
          <div class="showtimes" id="today-showtimes">
            <c:choose>
              <c:when test="${not empty todaySchedules}">
                <div class="showtime-slots">
                  <c:forEach var="schedule" items="${todaySchedules}">
                    <div class="time-slot selectable" data-theater="${schedule.theaterLocation}" data-schedule-id="${schedule.scheduleId}">
                      ${schedule.formattedTime}
                      <span class="price">${schedule.formattedPrice}</span>
                      <span class="hall">Hall: ${schedule.hallNumber}</span>
                      <span class="format">${schedule.languageFormat}</span>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="no-schedules">No showtimes available for Today</div>
              </c:otherwise>
            </c:choose>
          </div>
          
          <div class="showtimes" id="tomorrow-showtimes" style="display: none;">
            <c:choose>
              <c:when test="${not empty tomorrowSchedules}">
                <div class="showtime-slots">
                  <c:forEach var="schedule" items="${tomorrowSchedules}">
                    <div class="time-slot selectable" data-theater="${schedule.theaterLocation}" data-schedule-id="${schedule.scheduleId}">
                      ${schedule.formattedTime}
                      <span class="price">${schedule.formattedPrice}</span>
                      <span class="hall">Hall: ${schedule.hallNumber}</span>
                      <span class="format">${schedule.languageFormat}</span>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="no-schedules">No showtimes available for Tomorrow</div>
              </c:otherwise>
            </c:choose>
          </div>
          
          <div class="showtimes" id="dayafter-showtimes" style="display: none;">
            <c:choose>
              <c:when test="${not empty dayAfterSchedules}">
                <div class="showtime-slots">
                  <c:forEach var="schedule" items="${dayAfterSchedules}">
                    <div class="time-slot selectable" data-theater="${schedule.theaterLocation}" data-schedule-id="${schedule.scheduleId}">
                      ${schedule.formattedTime}
                      <span class="price">${schedule.formattedPrice}</span>
                      <span class="hall">Hall: ${schedule.hallNumber}</span>
                      <span class="format">${schedule.languageFormat}</span>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="no-schedules">No showtimes available for Day After</div>
              </c:otherwise>
            </c:choose>
          </div>
          
          <form id="booking-form" action="<%= request.getContextPath() %>/user/booking" method="get">
            <input type="hidden" name="scheduleId" id="selected-schedule-id">
            <button type="submit" class="book-btn" id="book-ticket-btn" disabled>
              <i class="fas fa-ticket-alt"></i> Book Tickets
            </button>
            <div id="selection-required-message" class="error-message" style="color: #ff4757; margin-top: 10px; text-align: center; display: none;">
              Please select a theater and showtime first
            </div>
            <div id="debug-info" style="margin-top: 10px; font-size: 12px; color: #666;">
              Selected Schedule ID: <span id="debug-schedule-id">None</span>
              <c:if test="${not empty todaySchedules}">
                <div style="margin-top: 5px;">
                  <a href="<%= request.getContextPath() %>/user/booking?scheduleId=${todaySchedules[0].scheduleId}" 
                     style="text-decoration: underline; color: #0066cc; font-size: 11px;">
                    Debug: Test booking page with first schedule
                  </a>
                </div>
              </c:if>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="user-footer.jsp" />
  
  <% if (request.getParameter("debug") != null) { %>
  <script>
    // Debug script that runs only in debug mode
    document.addEventListener('DOMContentLoaded', function() {
      const debugBtn = document.createElement('button');
      debugBtn.textContent = 'Check slot attributes';
      debugBtn.style.marginTop = '10px';
      debugBtn.style.padding = '5px';
      debugBtn.addEventListener('click', function() {
        document.querySelectorAll('.time-slot').forEach(slot => {
          console.log('Slot:', slot);
          console.log('  data-theater:', slot.getAttribute('data-theater'));
          console.log('  innerHTML:', slot.innerHTML);
        });
      });
      document.querySelector('.container').appendChild(debugBtn);
    });
  </script>
  <% } %>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Date tabs functionality
      const dateTabs = document.querySelectorAll('.date-tab');
      const showtimes = document.querySelectorAll('.showtimes');
      const bookTicketBtn = document.getElementById('book-ticket-btn');
      const selectedScheduleId = document.getElementById('selected-schedule-id');
      const selectionMessage = document.getElementById('selection-required-message');
      const debugScheduleId = document.getElementById('debug-schedule-id');
      let selectedTimeSlot = null;
      
      // Initialize time slot selection
      document.querySelectorAll('.time-slot.selectable').forEach(slot => {
        slot.addEventListener('click', function() {
          // Deselect previously selected time slot
          if (selectedTimeSlot) {
            selectedTimeSlot.classList.remove('selected');
          }
          
          // Select current time slot
          this.classList.add('selected');
          selectedTimeSlot = this;
          
          // Set the selected schedule ID
          const scheduleId = this.getAttribute('data-schedule-id');
          selectedScheduleId.value = scheduleId;
          debugScheduleId.textContent = scheduleId;
          
          // Enable the book button
          bookTicketBtn.disabled = false;
          selectionMessage.style.display = 'none';
        });
      });
      
      // Validate form submission
      document.getElementById('booking-form').addEventListener('submit', function(event) {
        if (!selectedScheduleId.value) {
          event.preventDefault();
          selectionMessage.style.display = 'block';
          return false;
        }
        // Let the form submit normally - removing the custom redirect code
        return true;
      });
      
      dateTabs.forEach(tab => {
        tab.addEventListener('click', function() {
          // Remove active class from all tabs
          dateTabs.forEach(t => t.classList.remove('active'));
          
          // Add active class to clicked tab
          this.classList.add('active');
          
          // Hide all showtimes
          showtimes.forEach(s => s.style.display = 'none');
          
          // Show the selected day's showtimes
          const day = this.getAttribute('data-day');
          document.getElementById(day + '-showtimes').style.display = 'block';
        });
      });
      
      // Theater selector functionality
      const theaterSelect = document.getElementById('theaterSelect');
      if (theaterSelect) {
        theaterSelect.addEventListener('change', function() {
          const selectedTheater = this.value;
          console.log('Selected theater:', selectedTheater);
          
          // Filter showtimes based on selected theater
          document.querySelectorAll('.time-slot').forEach(slot => {
            const slotTheater = slot.getAttribute('data-theater');
            console.log('Slot theater:', slotTheater, 'Selected:', selectedTheater);
            
            if (slotTheater === selectedTheater || selectedTheater === 'all') {
              slot.style.display = 'inline-block';
            } else {
              slot.style.display = 'none';
            }
          });
        });
      }
    });
  </script>
</body>
</html> 