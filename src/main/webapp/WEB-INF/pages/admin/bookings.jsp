<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Management - ReelGood Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            margin: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2f3542;
            font-size: 24px;
        }

        .booking-cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .booking-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .booking-id {
            font-weight: 600;
            color: #2f3542;
        }

        .booking-status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-confirmed {
            background-color: #2ed573;
            color: white;
        }

        .status-pending {
            background-color: #ffa502;
            color: white;
        }

        .status-cancelled {
            background-color: #ff4757;
            color: white;
        }

        .booking-details {
            margin-bottom: 15px;
        }

        .booking-detail {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .detail-label {
            color: #666;
        }

        .detail-value {
            color: #2f3542;
            font-weight: 500;
        }

        .booking-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn-primary {
            background-color: #ff4757;
            color: white;
        }

        .btn-primary:hover {
            background-color: #ff6b81;
        }

        .btn-secondary {
            background-color: #f1f2f6;
            color: #2f3542;
        }

        .btn-secondary:hover {
            background-color: #dfe4ea;
        }

        .error-message {
            color: #ff4757;
            font-size: 14px;
            margin-top: 10px;
        }

        .success-message {
            color: #2ecc71;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .filter-box {
            padding: 10px 15px;
            background: #f1f2f6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .filter-box:hover, .filter-box.active {
            background: #dfe4ea;
        }
        
        .filter-box.active {
            background: #ff4757;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="components/sidebar.jsp" />

        <div class="main-content">
            <div class="header">
                <h1>Booking Management</h1>
            </div>

            <% 
                String errorMessage = (String) request.getAttribute("error");
                String successMessage = request.getParameter("success");
            %>

            <% if (errorMessage != null) { %>
                <div class="error-message"><%= errorMessage %></div>
            <% } %>

            <% if (successMessage != null) { %>
                <div class="success-message"><%= successMessage %></div>
            <% } %>
            
            <div class="filters">
                <div class="filter-box all active" onclick="filterBookings('all')">
                    <i class="fas fa-list"></i>
                    <span>All Bookings</span>
                </div>
                <div class="filter-box confirmed" onclick="filterBookings('Confirmed')">
                    <i class="fas fa-check-circle"></i>
                    <span>Confirmed</span>
                </div>
                <div class="filter-box cancelled" onclick="filterBookings('Cancelled')">
                    <i class="fas fa-times-circle"></i>
                    <span>Cancelled</span>
                </div>
            </div>
            
            <div class="booking-cards-container">
                <c:forEach var="booking" items="${bookings}">
                    <div class="booking-card" data-status="${booking.status}">
                        <div class="booking-header">
                            <div class="booking-id">Booking #${booking.id}</div>
                            <div class="booking-status status-${booking.status.toLowerCase()}">${booking.status}</div>
                        </div>
                        <div class="booking-details">
                            <div class="booking-detail">
                                <div class="detail-label">User</div>
                                <div class="detail-value">${booking.username} (ID: ${booking.userId})</div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Movie</div>
                                <div class="detail-value">${booking.movieTitle}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Theater</div>
                                <div class="detail-value">${booking.theaterLocation}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Show Time</div>
                                <div class="detail-value">${booking.showDate} at ${booking.showTime}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Seats</div>
                                <div class="detail-value">${booking.seats} (${booking.numberOfSeats} seats)</div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Payment</div>
                                <div class="detail-value">
                                    Total: ₹${booking.totalAmount}<br>
                                    Fee: ₹${booking.bookingFee}
                                </div>
                            </div>
                            <div class="booking-detail">
                                <div class="detail-label">Booked On</div>
                                <div class="detail-value">${booking.createdAt}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <script>
        function filterBookings(status) {
            // Update active filter
            document.querySelectorAll('.filter-box').forEach(box => {
                box.classList.remove('active');
            });
            document.querySelector('.filter-box.' + (status === 'all' ? 'all' : status.toLowerCase())).classList.add('active');
            
            // Filter bookings
            const bookingCards = document.querySelectorAll('.booking-card');
            bookingCards.forEach(card => {
                if (status === 'all' || card.getAttribute('data-status').toLowerCase() === status.toLowerCase()) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/bookings/cancel?id=' + bookingId;
            }
        }
        
        function restoreBooking(bookingId) {
            if (confirm('Are you sure you want to restore this booking?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/bookings/restore?id=' + bookingId;
            }
        }
    </script>
</body>
</html> 