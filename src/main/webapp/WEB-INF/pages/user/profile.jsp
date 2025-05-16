<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - ReelGood</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <jsp:include page="user-navbar.jsp" />
</head>

<body>
    <div class="page-wrapper">
        
        
        <div class="container profile-layout">
            <div class="profile-sidebar">
                <ul class="sidebar-menu">
                    <li><a href="#" class="sidebar-link active" data-section="info" onclick="showProfileSection('info'); return false;"><i class="fas fa-user"></i> My Profile</a></li>
                    <li><a href="#" class="sidebar-link" data-section="bookings" onclick="showProfileSection('bookings'); return false;"><i class="fas fa-ticket-alt"></i> My Bookings</a></li>
                    <li>
                        <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                            <button type="submit" class="btn btn-danger btn-block" style="width: 100%; margin-top: 10px;">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </button>
                        </form>
                    </li>
                </ul>
            </div>
            <div class="profile-main">
                <div id="profile-info-section" class="profile-section-content active">
                    <h2>Personal Information</h2>
                    <form action="<%= request.getContextPath() %>/profile" method="post" class="profile-form">
                        <input type="hidden" name="action" value="update">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" value="${user.username}" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" value="${user.phone}">
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" rows="3">${user.address}</textarea>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Update Profile</button>
                        </div>
                    </form>
                </div>
                <div id="profile-bookings-section" class="profile-section-content">
                    <h2>My Bookings</h2>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <p class="text-muted">No bookings found.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="bookings-list">
                                <c:forEach var="booking" items="${bookings}">
                                    <div class="booking-card">
                                        <div class="booking-header">
                                            <h3>${booking.movieTitle}</h3>
                                            <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                                        </div>
                                        <div class="booking-details">
                                            <p><i class="fas fa-calendar"></i> ${booking.showDate}</p>
                                            <p><i class="fas fa-clock"></i> ${booking.showTime}</p>
                                            <p><i class="fas fa-map-marker-alt"></i> Theater: ${booking.theaterLocation}</p>
                                            <p><i class="fas fa-chair"></i> Seats: ${booking.seats}</p>
                                            <p><i class="fas fa-ticket-alt"></i> Number of Seats: ${booking.numberOfSeats}</p>
                                            <p><i class="fas fa-dollar-sign"></i> Total Amount: ₹${booking.totalAmount}</p>
                                            <p><i class="fas fa-receipt"></i> Booking Fee: ₹${booking.bookingFee}</p>
                                            <p><i class="fas fa-calendar-alt"></i> Booked on: ${booking.createdAt}</p>
                                        </div>
                                        <c:if test="${booking.status eq 'Confirmed'}">
                                            <div class="booking-actions">
                                                <form action="${pageContext.request.contextPath}/user/profile" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="bookingId" value="${booking.id}">
                                                    <button type="submit" class="btn btn-danger"
                                                            onclick="return confirm('Are you sure you want to cancel this booking?')">
                                                        Cancel Booking
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <jsp:include page="user-footer.jsp" />
    </div>

    <style>
        body {
            background: #2a1616;
        }
        .profile-layout {
            display: flex;
            gap: 2rem;
            margin-top: 2rem;
        }
        .profile-sidebar {
            min-width: 240px;
            max-width: 260px;
            background: linear-gradient(135deg, #232526 0%, #1a1a1a 100%);
            color: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.13);
            padding: 2.5rem 1.25rem 2rem 1.25rem;
            height: fit-content;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .profile-info, .profile-picture { display: none !important; }
        .profile-sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
            width: 100%;
        }
        .profile-sidebar li {
            margin-bottom: 1rem;
            width: 100%;
        }
        .profile-sidebar a.sidebar-link {
            color: #fff;
            text-decoration: none;
            padding: 13px 20px;
            display: flex;
            align-items: center;
            border-radius: 8px;
            font-size: 1.08rem;
            gap: 0.85rem;
            font-weight: 500;
            letter-spacing: 0.01em;
            transition: background 0.18s, color 0.18s, box-shadow 0.18s;
            box-shadow: none;
        }
        .profile-sidebar a.sidebar-link.active, .profile-sidebar a.sidebar-link:hover {
            background: #ff4757;
            color: #fff;
            box-shadow: 0 2px 8px rgba(255,71,87,0.10);
        }
        .profile-sidebar i {
            width: 22px;
            text-align: center;
            font-size: 1.15em;
        }
        .btn-danger.btn-block {
            background: #ff4757;
            color: #fff;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            margin-top: 1.5rem;
            padding: 12px 0;
            width: 100%;
            border: none;
            transition: background 0.18s;
        }
        .btn-danger.btn-block:hover {
            background: #ff6b81;
        }
        .profile-main {
            flex: 1;
            padding: 2rem;
        }
        .profile-section-content {
            display: none;
        }
        .profile-section-content.active {
            display: block;
        }
        .profile-section {
            padding: 2rem 0;
        }
        .profile-content {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            margin-top: 2rem;
        }
        @media (min-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr 1fr;
            }
        }
        .profile-info, .profile-bookings {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .profile-form {
            margin-top: 1rem;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #444;
            border-radius: 4px;
            background: #231818;
            color: #fff;
        }
        .booking-card {
            background: #231818;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            color: #fff;
        }
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .booking-header h3 {
            color: #fff;
        }
        .booking-status {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .booking-status.confirmed {
            background: #2ed573;
            color: white;
        }
        .booking-status.cancelled {
            background: #ff4757;
            color: white;
        }
        .booking-status.completed {
            background: #747d8c;
            color: white;
        }
        .booking-details {
            margin: 1rem 0;
        }
        .booking-details p {
            margin: 0.5rem 0;
            color: #e0e0e0;
        }
        .booking-details i {
            width: 20px;
            margin-right: 0.5rem;
            color: #ff4757;
        }
        .booking-actions {
            margin-top: 1rem;
            text-align: right;
        }
        .btn-danger {
            background: #ff4757;
            color: white;
        }
        .btn-danger:hover {
            background: #ff6b81;
        }
    </style>
    <script>
        function showProfileSection(section) {
            document.querySelectorAll('.sidebar-link').forEach(link => {
                link.classList.toggle('active', link.getAttribute('data-section') === section);
            });
            document.querySelectorAll('.profile-section-content').forEach(content => {
                content.classList.remove('active');
            });
            if (section === 'info') {
                document.getElementById('profile-info-section').classList.add('active');
            } else if (section === 'bookings') {
                document.getElementById('profile-bookings-section').classList.add('active');
            }
        }
        document.addEventListener('DOMContentLoaded', function() {
            // Check for ?section=bookings in the URL
            const params = new URLSearchParams(window.location.search);
            if (params.get('section') === 'bookings') {
                showProfileSection('bookings');
            } else {
                showProfileSection('info');
            }
        });
    </script>
</body>
</html> 