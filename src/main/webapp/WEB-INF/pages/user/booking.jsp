<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Select Seats - ${movie.title} - ReelGood</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .seat-icon.available, .seat.available {
      background: #2196f3 !important;
      border: 2px solid #fff;
      box-shadow: 0 0 6px #2196f3, 0 2px 8px rgba(0,0,0,0.15);
    }
    .seat {
      width: 32px;
      height: 32px;
      margin: 4px;
      border-radius: 6px;
      display: inline-block;
      background: #2196f3; /* Bright blue for available */
      border: 2px solid #fff;
      cursor: pointer;
      transition: background 0.2s, border 0.2s;
    }
    .seat.selected {
      background: #ff4757 !important;
      border: 2px solid #b71c1c;
    }
    .seat.taken {
      background: #bdbdbd !important;
      border: 2px solid #888;
      cursor: not-allowed;
    }
  </style>
</head>
<body>
  <jsp:include page="user-navbar.jsp" />
  <div class="container mt-4">
    <a href="<%= request.getContextPath() %>/user/movie-details?movieId=${movie.id}" class="back-link" id="back-to-movie">← Back to movie</a>
    <div class="booking-layout">
      <div class="booking-main">
        <h1>Select Your Seats</h1>
        <div class="booking-meta">
          <div class="meta-item">
            <i class="fa-solid fa-calendar-days"></i>
            <span id="booking-date">${schedule.showDay}</span>
          </div>
          <span class="separator">•</span>
          <div class="meta-item">
            <i class="fa-regular fa-clock"></i>
            <span id="booking-time">${schedule.formattedTime}</span>
          </div>
          <span class="separator">•</span>
          <div class="meta-item">
            <i class="fa-solid fa-location-dot"></i>
            <span>${schedule.theaterLocation}</span>
          </div>
        </div>
        <div class="seat-selection">
          <div class="seat-legend">
            <div class="legend-item">
              <div class="seat-icon available"></div>
              <span>Available</span>
            </div>
            <div class="legend-item">
              <div class="seat-icon selected"></div>
              <span>Selected</span>
            </div>
            <div class="legend-item">
              <div class="seat-icon taken"></div>
              <span>Taken</span>
            </div>
          </div>
          <div class="theater-layout">
            <div class="screen">SCREEN</div>
            <div class="seats-container" id="seats-container"></div>
          </div>
        </div>
      </div>
      <div class="booking-sidebar">
        <div class="booking-summary">
          <div class="summary-header">
            <h2>Booking Summary</h2>
          </div>
          <div class="summary-content">
            <div class="movie-info-summary">
              <h3 id="movie-title">${movie.title}</h3>
              <div class="movie-meta" id="movie-meta">
                <span>${movie.duration} min</span>
                <span class="separator">•</span>
                <span>${movie.genre}</span>
                <span class="separator">•</span>
                <span>${movie.language}</span>
              </div>
            </div>
            <div class="booking-details">
              <div class="detail-item">
                <span class="detail-label">Date:</span>
                <span id="summary-date">${schedule.showDay}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Time:</span>
                <span id="summary-time">${schedule.formattedTime}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Theater:</span>
                <span>${schedule.theaterLocation}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Hall:</span>
                <span>${schedule.hallNumber}</span>
              </div>
            </div>
            <div class="divider"></div>
            <div class="selected-seats-summary">
              <div class="detail-item">
                <span class="detail-label">Selected Seats:</span>
                <span id="selected-seats-list">None</span>
              </div>
              <div class="price-item">
                <span>Regular Seats (<span id="seat-count">0</span>)</span>
                <span id="seats-price">Rs 0.00</span>
              </div>
              <div class="price-item">
                <div class="tooltip-container">
                  <span>Booking Fee</span>
                  <div class="tooltip-icon">
                    <i class="fa-solid fa-circle-info"></i>
                    <div class="tooltip">A small fee to maintain our booking platform.</div>
                  </div>
                </div>
                <span id="booking-fee">Rs ${bookingFee}</span>
              </div>
            </div>
            <div class="divider"></div>
            <div class="total-price">
              <span>Total</span>
              <span id="total-price">Rs 0.00</span>
            </div>
          </div>
          <div class="summary-footer">
            <form id="booking-form" action="<%= request.getContextPath() %>/user/booking" method="post">
              <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
              <input type="hidden" name="selectedSeats" id="selected-seats-input">
              <button type="submit" class="btn btn-primary btn-block" id="checkout-btn" disabled>Proceed to Payment</button>
            </form>
          </div>
        </div>
        <div class="booking-note">
          <p>You can select up to 8 seats per booking.</p>
        </div>
      </div>
    </div>
  </div>
  <jsp:include page="user-footer.jsp" />
  <script>
    // Store booked seats from server
    const bookedSeats = [
      <c:forEach var="seat" items="${bookedSeats}" varStatus="status">
        "${seat}"<c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ];
    // Store seat price from server
    const seatPrice = parseFloat("${schedule.pricePerSeat}");
    const bookingFeeCost = parseFloat("${bookingFee}");
    document.addEventListener('DOMContentLoaded', function() {
      const seatsContainer = document.getElementById('seats-container');
      const selectedSeatsList = document.getElementById('selected-seats-list');
      const seatCountElement = document.getElementById('seat-count');
      const seatsPriceElement = document.getElementById('seats-price');
      const totalPriceElement = document.getElementById('total-price');
      const checkoutBtn = document.getElementById('checkout-btn');
      const selectedSeatsInput = document.getElementById('selected-seats-input');
      const backButton = document.getElementById('back-to-movie');
      // Set back button URL
      backButton.href = "<%= request.getContextPath() %>/user/movie-details?movieId=${movie.id}";
      // Create seat layout (8 rows, 10 seats per row)
      const rows = 8;
      const seatsPerRow = 10;
      const selectedSeats = [];
      // Generate seat layout
      for (let row = 0; row < rows; row++) {
        const seatRow = document.createElement('div');
        seatRow.className = 'seat-row';
        // Add row label - use A, B, C, etc. based on row number
        const rowLabel = document.createElement('div');
        rowLabel.className = 'row-label';
        // Convert row number to letter (0 = A, 1 = B, etc.)
        const rowLetter = String.fromCharCode(65 + row);
        rowLabel.textContent = rowLetter;
        seatRow.appendChild(rowLabel);
        for (let seat = 1; seat <= seatsPerRow; seat++) {
          // Create seat ID like A1, A2, B1, B2, etc.
          const seatId = rowLetter + seat;
          const seatElement = document.createElement('div');
          seatElement.className = 'seat';
          seatElement.dataset.id = seatId;
          // Check if seat is already booked
          if (bookedSeats.includes(seatId)) {
            seatElement.classList.add('taken');
          } else {
            seatElement.addEventListener('click', function() {
              if (this.classList.contains('taken')) return;
              if (this.classList.contains('selected')) {
                // Deselect seat
                this.classList.remove('selected');
                const index = selectedSeats.indexOf(seatId);
                if (index > -1) {
                  selectedSeats.splice(index, 1);
                }
              } else {
                // Limit to 8 seats
                if (selectedSeats.length >= 8) {
                  alert('You can only select up to 8 seats per booking.');
                  return;
                }
                // Select seat
                this.classList.add('selected');
                selectedSeats.push(seatId);
              }
              // Update selected seats display and price
              updateSelectedSeats();
            });
          }
          seatRow.appendChild(seatElement);
        }
        seatsContainer.appendChild(seatRow);
      }
      function updateSelectedSeats() {
        if (selectedSeats.length === 0) {
          selectedSeatsList.textContent = 'None';
          seatCountElement.textContent = '0';
          seatsPriceElement.textContent = 'Rs 0.00';
          totalPriceElement.textContent = 'Rs ' + bookingFeeCost.toFixed(2);
          checkoutBtn.disabled = true;
          selectedSeatsInput.value = '';
        } else {
          // Sort seats for better display
          selectedSeats.sort();
          selectedSeatsList.textContent = selectedSeats.join(', ');
          seatCountElement.textContent = selectedSeats.length;
          // Calculate prices
          const seatsTotal = selectedSeats.length * seatPrice;
          const total = seatsTotal + bookingFeeCost;
          seatsPriceElement.textContent = 'Rs ' + seatsTotal.toFixed(2);
          totalPriceElement.textContent = 'Rs ' + total.toFixed(2);
          checkoutBtn.disabled = false;
          selectedSeatsInput.value = selectedSeats.join(',');
        }
      }
    });
  </script>
</body>
</html> 