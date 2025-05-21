<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <jsp:include page="user-navbar.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment - ${movie.title} - ReelGood</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .payment-layout {
      display: flex;
      flex-wrap: wrap;
      gap: 30px;
      margin-top: 20px;
    }
    
    .payment-main {
      flex: 1;
      min-width: 320px;
    }
    
    .payment-sidebar {
      width: 350px;
    }
    
    .payment-summary {
      background: #231818;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      overflow: hidden;
      margin-bottom: 20px;
    }
    
    .summary-header {
      padding: 15px 20px;
      border-bottom: 1px solid #eee;
    }
    
    .summary-header h2 {
      margin: 0;
      font-size: 18px;
      color: white;
    }
    
    .summary-content {
      padding: 20px;
    }
    
    .summary-footer {
      padding: 15px 20px;
      border-top: 1px solid #eee;
      background: var(--footer);
    }
    
    .movie-info-summary h3 {
      margin: 0 0 5px;
      font-size: 20px;
    }
    
    .movie-meta {
      font-size: 14px;
      color: #666;
      margin-bottom: 15px;
    }
    
    .movie-meta .separator {
      margin: 0 8px;
      color: #ddd;
    }
    
    .booking-details {
      margin-bottom: 20px;
    }
    
    .detail-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
      font-size: 14px;
    }
    
    .detail-label {
      color: #666;
    }
    
    .selected-seats-summary {
      margin-bottom: 20px;
    }
    
    .price-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
      font-size: 14px;
    }
    
    .divider {
      height: 1px;
      background: #eee;
      margin: 15px 0;
    }
    
    .total-price {
      display: flex;
      justify-content: space-between;
      font-weight: 600;
      font-size: 18px;
    }
    
    .tooltip-container {
      position: relative;
      display: inline-block;
    }
    
    .tooltip-icon {
      display: inline-flex;
      margin-left: 5px;
      color: #999;
      cursor: help;
    }
    
    .tooltip {
      visibility: hidden;
      width: 200px;
      background-color: #333;
      color: #fff;
      text-align: center;
      border-radius: 6px;
      padding: 10px;
      position: absolute;
      z-index: 1;
      bottom: 125%;
      left: 50%;
      transform: translateX(-50%);
      opacity: 0;
      transition: opacity 0.3s;
      font-size: 12px;
      pointer-events: none;
    }
    
    .tooltip-icon:hover .tooltip {
      visibility: visible;
      opacity: 1;
    }
    
    .payment-methods {
      background: #231818;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      padding: 20px;
      margin-bottom: 20px;
    }
    
    .payment-methods h2 {
      margin-top: 0;
      margin-bottom: 15px;
      font-size: 18px;
    }
    
    .payment-method {
      border: 1px solid #444;
      background: #2a1616;
      color: #fff;
      border-radius: 6px;
      padding: 15px;
      margin-bottom: 15px;
      cursor: pointer;
      transition: all 0.2s;
    }
    
    .payment-method:hover {
      border-color: #ccc;
      background: #B7DB97;
    }
    
    .payment-method.selected {
      border-color: #B7DB97;
      background: #2a1616;
      color: #B7DB97;
    }
    
    .payment-method-header {
      display: flex;
      align-items: center;
    }
    
    .payment-method-radio {
      margin-right: 10px;
    }
    
    .payment-method-icon {
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 10px;
      font-size: 20px;
    }
    
    .payment-method-title {
      font-weight: 500;
    }
    
    .payment-method-description {
      margin-top: 10px;
      font-size: 14px;
      color: #e0e0e0;
      padding-left: 50px;
      display: none;
    }
    
    
    .card-form {
      margin-top: 15px;
      padding-left: 30px;
      display: none;
    }
    
    .card-form.active {
      display: block;
    }
    
    .form-group {
      margin-bottom: 15px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-size: 14px;
      color: #555;
    }
    
    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    
    .card-row {
      display: flex;
      gap: 15px;
    }
    
    .card-col {
      flex: 1;
    }
    
    .btn-block {
      width: 100%;
    }
    
    .timer-container {
      text-align: center;
      margin-bottom: 20px;
      padding: 10px;
      background-color: #231818;
      border-radius: 5px;
      color: #fff;
    }
    
    .timer {
      font-size: 16px;
      font-weight: 600;
      color: #ff4757;
    }
    
    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #666;
      text-decoration: none;
      transition: color 0.2s;
    }
    
    .back-link:hover {
      color: #ff4757;
    }
  </style>
</head>
<body>

  
  <div class="container">
   

    <div class="timer-container">
      <div class="timer" id="countdown">
        <i class="fas fa-clock"></i> Time remaining: <span id="minutes">10</span>:<span id="seconds">00</span>
      </div>
    </div>

    <div class="payment-layout">
      <div class="payment-main">
        <h1>Payment</h1>
        
        <div class="payment-methods">
          <h2>Select Payment Method</h2>
          
          <div class="payment-method selected" data-method="card">
            <div class="payment-method-header">
              <input type="radio" name="payment-method" id="card-payment" class="payment-method-radio" checked>
              <div class="payment-method-icon">
                <i class="fas fa-credit-card"></i>
              </div>
              <label for="card-payment" class="payment-method-title">Credit / Debit Card</label>
            </div>
            
          </div>
          
          <div class="payment-method" data-method="upi">
            <div class="payment-method-header">
              <input type="radio" name="payment-method" id="upi-payment" class="payment-method-radio">
              <div class="payment-method-icon">
                <i class="fas fa-mobile-alt"></i>
              </div>
              <label for="upi-payment" class="payment-method-title">UPI Payment</label>
            </div>
      
          </div>
          
          <div class="payment-method" data-method="netbanking">
            <div class="payment-method-header">
              <input type="radio" name="payment-method" id="netbanking-payment" class="payment-method-radio">
              <div class="payment-method-icon">
                <i class="fas fa-university"></i>
              </div>
              <label for="netbanking-payment" class="payment-method-title">Net Banking</label>
            </div>
            
          </div>
        </div>
      </div>

      <div class="payment-sidebar">
        <div class="payment-summary">
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
                <span id="selected-seats-list">${selectedSeats}</span>
              </div>

              <div class="price-item">
                <span>Regular Seats (${numberOfSeats})</span>
                <span id="seats-price">Rs ${seatTotal}</span>
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
              <span id="total-price">Rs ${totalAmount}</span>
            </div>
          </div>
          <div class="summary-footer">
            <form id="payment-form" action="<%= request.getContextPath() %>/user/payment" method="post">
              <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
              <input type="hidden" name="selectedSeats" value="${selectedSeats}">
              <input type="hidden" name="totalAmount" value="${totalAmount}">
              <input type="hidden" name="bookingFee" value="${bookingFee}">
              <input type="hidden" name="paymentMethod" id="payment-method-input" value="card">
              <button type="submit" class="btn btn-primary btn-block" id="pay-now-btn">Pay Now</button>
            </form>
          </div>
        </div>

        <div class="refund-policy" style="background: #081616 ; border-radius: 8px; padding: 15px; font-size: 14px; color: #666;">
          <h3 style="margin-top: 0; font-size: 16px; color:white">Cancellation Policy</h3>
          <p>Tickets can be cancelled up to 4 hours before showtime for a full refund.</p>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="user-footer.jsp" />

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Payment method selection
      const paymentMethods = document.querySelectorAll('.payment-method');
      const paymentMethodInput = document.getElementById('payment-method-input');
      const cardForm = document.querySelector('.card-form');
      
      paymentMethods.forEach(method => {
        method.addEventListener('click', function() {
          // Remove selected class from all methods
          paymentMethods.forEach(m => {
            m.classList.remove('selected');
            m.querySelector('input[type="radio"]').checked = false;
          });
          
          // Add selected class to clicked method
          this.classList.add('selected');
          this.querySelector('input[type="radio"]').checked = true;
          
          // Update hidden input
          const methodType = this.getAttribute('data-method');
          paymentMethodInput.value = methodType;
          
          // Show/hide card form
          if (methodType === 'card') {
            cardForm.classList.add('active');
          } else {
            cardForm.classList.remove('active');
          }
        });
      });
      
      // Timer functionality
      let minutes = 10;
      let seconds = 0;
      const minutesElement = document.getElementById('minutes');
      const secondsElement = document.getElementById('seconds');
      
      const timer = setInterval(function() {
        if (seconds === 0) {
          if (minutes === 0) {
            clearInterval(timer);
            alert('Your booking session has expired. You will be redirected to the home page.');
            window.location.href = '<%= request.getContextPath() %>/user/index';
            return;
          }
          minutes--;
          seconds = 59;
        } else {
          seconds--;
        }
        
        minutesElement.textContent = minutes < 10 ? '0' + minutes : minutes;
        secondsElement.textContent = seconds < 10 ? '0' + seconds : seconds;
      }, 1000);
      
      // Card input formatting
      const cardNumber = document.getElementById('card-number');
      if (cardNumber) {
        cardNumber.addEventListener('input', function(e) {
          let value = e.target.value.replace(/\D/g, '');
          value = value.replace(/(.{4})/g, '$1 ').trim();
          e.target.value = value;
        });
      }
      
      const expiry = document.getElementById('expiry');
      if (expiry) {
        expiry.addEventListener('input', function(e) {
          let value = e.target.value.replace(/\D/g, '');
          if (value.length > 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
          }
          e.target.value = value;
        });
      }
      
      const cvv = document.getElementById('cvv');
      if (cvv) {
        cvv.addEventListener('input', function(e) {
          let value = e.target.value.replace(/\D/g, '');
          e.target.value = value.substring(0, 3);
        });
      }
    });
  </script>

  <!-- DEBUG: Print schedule fields -->
  <pre>
  DEBUG: Theater: ${schedule.theaterLocation}
  DEBUG: Hall: ${schedule.hallNumber}
  </pre>
</body>
</html> 