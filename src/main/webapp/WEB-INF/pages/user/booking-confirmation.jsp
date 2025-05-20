<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="user-navbar.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Booking Confirmation - ReelGood</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
    .confirmation-container {
      max-width: 800px;
      margin: 50px auto;
      padding: 30px;
      background-color: #231818;
      border-radius: 8px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      text-align: center;
      color: #fff;
    }
    
    .confirmation-icon {
      font-size: 60px;
      color: #4BB543;
      margin-bottom: 20px;
    }
    
    .confirmation-title {
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 15px;
      color: #fff;
    }
    
    .confirmation-message {
      font-size: 16px;
      color: #e0e0e0;
      margin-bottom: 30px;
      max-width: 600px;
      margin-left: auto;
      margin-right: auto;
    }
    
    .booking-id {
      font-size: 18px;
      color: #081616;
      font-weight: 600;
      margin-bottom: 20px;
      background-color: #B7DB97;
      padding: 10px 20px;
      border-radius: 5px;
      display: inline-block;
    }
    
    .actions {
      margin-top: 30px;
    }
    
    .btn {
      background-color: #ff4757;
      color: white;
      border: none;
      padding: 12px 25px;
      border-radius: 4px;
      font-weight: 500;
      text-decoration: none;
      display: inline-block;
      transition: background-color 0.3s;
      margin: 0 10px;
    }
    
    .btn:hover {
      background-color: #ff6b81;
    }
    
    .btn-outline {
      background-color: transparent;
      color: #ff4757;
      border: 1px solid #ff4757;
    }
    
    .btn-outline:hover {
      background-color: #fff8f8;
    }
    
    .info-panel {
      background-color: #2a1616;
      color: #fff;
      padding: 20px;
      border-radius: 5px;
      margin-top: 30px;
      text-align: left;
    }
    
    .info-panel h3 {
      margin-top: 0;
      font-size: 18px;
      color: #fff;
      margin-bottom: 15px;
    }
    
    .info-panel p {
      margin-bottom: 10px;
      color: #e0e0e0;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="confirmation-container">
      <div class="confirmation-icon">
        <i class="fas fa-check-circle"></i>
      </div>
      <h1 class="confirmation-title">Booking Confirmed!</h1>
      <p class="confirmation-message">
        Your tickets have been successfully booked. A confirmation email has been sent to your registered email address.
      </p>
      
      <div class="booking-id">
        Booking ID: ${bookingId}
      </div>
      
      <div class="info-panel">
        <h3>Important Information</h3>
        <p><i class="fas fa-info-circle"></i> Please arrive at the theater at least 15 minutes before the show.</p>
        <p><i class="fas fa-info-circle"></i> Show your booking ID at the counter to collect your tickets.</p>
        <p><i class="fas fa-info-circle"></i> Cancellations are allowed up to 4 hours before the show time.</p>
      </div>
      
      <div class="actions">
        <a href="<%= request.getContextPath() %>/user/index" class="btn">
          <i class="fas fa-home"></i> Go to Homepage
        </a>
        <a href="<%= request.getContextPath() %>/user/profile?section=bookings" class="btn btn-outline">
          <i class="fas fa-ticket-alt"></i> View My Bookings
        </a>
      </div>
    </div>
  </div>

  <jsp:include page="user-footer.jsp" />
</body>
</html> 