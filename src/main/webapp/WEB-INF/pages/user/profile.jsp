<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="user-navbar.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - ReelGood</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
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
            position: sticky;
            top: 32px;
            align-self: flex-start;
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
        
        a.sidebar-link.active{
        background: #373535;
        }
        
       a.sidebar-link:hover {
            background: #081616;
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
            box-shadow: 0 4px 24px rgba(0,0,0,0.18);
            background: #231818;
            border-radius: 16px;
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
            border: 3px solid #0C2121;
            border-radius: 50px;
            background: #231818;
            color: #fff;
        }
        .booking-card {
            background: #1E1E1E;
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

        /* Profile Photo Modals and Buttons */
        .profile-modal-bg {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        .profile-modal {
            background: #231818;
            color: #fff;
            padding: 32px 24px;
            border-radius: 12px;
            max-width: 350px;
            width: 90%;
            text-align: center;
            box-shadow: 0 4px 24px rgba(0,0,0,0.18);
            position: relative;
        }
        .profile-modal .modal-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }
        .profile-modal .modal-icon.confirm { color: #ffcc00; }
        .profile-modal .modal-icon.success { color: #4BB543; }
        .profile-modal .modal-icon.error { color: #ff4757; }
        .profile-modal h2 {
            margin-bottom: 12px;
        }
        .profile-modal p {
            margin-bottom: 24px;
        }
        .profile-modal .modal-btn {
            padding: 10px 28px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            margin-right: 10px;
        }
        .profile-modal .modal-btn.confirm {
            background: #4BB543;
            color: #fff;
        }
        .profile-modal .modal-btn.delete {
            background: #ff4757;
            color: #fff;
        }
        .profile-modal .modal-btn.cancel {
            background: #fff;
            color: #ff4757;
            border: 1.5px solid #ff4757;
            margin-right: 0;
        }
        .hidden-form { display: none; }
        .profile-photo-circle {
            width: 96px;
            height: 96px;
            border: 2.5px dashed #ff4757;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #231818;
            position: relative;
            overflow: hidden;
            margin: 0 auto;
        }
        .profile-photo-circle img,
        .profile-photo-circle .fa-user {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            display: block;
            position: absolute;
            left: 0;
            top: 0;
        }
        .profile-photo-circle .fa-user {
            color: #ff4757;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
        }
    </style>

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
                    <!-- Profile Photo Upload UI -->
                    <div style="display: flex; align-items: center; gap: 2rem; margin-bottom: 2rem;">
                        <div class="profile-photo-circle">
                            <img id="profilePhotoPreview" src="<%= request.getContextPath() %>/user-photo?id=${user.userID}" alt="Profile Photo" />
                            <span id="profilePhotoPlaceholder"><i class="fas fa-user"></i></span>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/*" style="display: none;" form="photoUploadForm" />
                                <span style="background: #282626; color: #fff; border: none; padding: 8px 20px; border-radius: 50px; font-weight: 500; cursor: pointer;">Upload Photo</span>
                            </label>
                            <button type="button" id="deletePhotoBtn" style="background: #f62428; color: white;  padding: 8px 20px; border-radius: 50px; font-weight: 500; cursor: pointer;">Delete Photo</button>
                        </div>
                    </div>
                    <!-- Hidden form for photo upload -->
                    <form id="photoUploadForm" action="<%= request.getContextPath() %>/user/profile/photo" method="post" enctype="multipart/form-data" style="display:none;">
                        <input type="file" id="hiddenProfilePhotoInput" name="profilePhoto" accept="image/*" />
                    </form>
                    <!-- Modal for photo confirmation -->
                    <div id="photoConfirmModal" style="display:none;position:fixed;z-index:1000;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;">
                      <div style="background:#231818;color:#fff;padding:32px 24px;border-radius:12px;max-width:350px;width:90%;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,0.18);position:relative;">
                        <div style="font-size:48px;color:#ffcc00;margin-bottom:12px;"><i class="fas fa-question-circle"></i></div>
                        <h2 style="margin-bottom:12px;">Confirm Profile Picture?</h2>
                        <p style="margin-bottom:24px;">Do you want to set this as your profile photo?</p>
                        <button id="confirmPhotoBtn" style="background:#4BB543;color:#fff;border:none;padding:10px 28px;border-radius:6px;font-weight:500;cursor:pointer;margin-right:10px;">Confirm</button>
                        <button id="cancelPhotoBtn" style="background:#ff4757;color:#fff;border:none;padding:10px 28px;border-radius:6px;font-weight:500;cursor:pointer;">Cancel</button>
                      </div>
                    </div>
                    <h2>Personal Information</h2>
                    <form action="<%= request.getContextPath() %>/user/profile" method="post" class="profile-form" enctype="multipart/form-data">
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
                    <!-- Account Delete Section (only in My Profile) -->
                    <div class="account-delete-section" style="margin-top: 2.5rem; padding: 2rem; background: #282626; border-radius: 12px; box-shadow: 0 2px 8px rgba(255,71,87,0.10);">
                      <h2 style="color: #ff4757; margin-bottom: 1rem;">Delete Account</h2>
                      <c:if test="${param.error == 'account_delete_failed'}">
                        <div class="alert alert-danger" style="margin-bottom: 1rem; padding: 1rem; background: rgba(255,71,87,0.1); border-radius: 8px; color: #ff4757;">
                          Failed to delete account. Please try again later.
                        </div>
                      </c:if>
                      <c:if test="${param.error == 'account_not_found'}">
                        <div class="alert alert-danger" style="margin-bottom: 1rem; padding: 1rem; background: rgba(255,71,87,0.1); border-radius: 8px; color: #ff4757;">
                          Account not found. Please try logging in again.
                        </div>
                      </c:if>
                      <c:if test="${param.error == 'account_has_dependencies'}">
                        <div class="alert alert-danger" style="margin-bottom: 1rem; padding: 1rem; background: rgba(255,71,87,0.1); border-radius: 8px; color: #ff4757;">
                          ERROR: Cannot delete account because it has active bookings. Please clear all your bookings or <a href="${pageContext.request.contextPath}/user/contact"><u>Contact Us</u></a>
                        </div>
                      </c:if>
                      <p style="color: #fff; margin-bottom: 1.5rem;">Warning: Deleting your account is <b>permanent</b> and cannot be <b>undone.</b> All your data, bookings, and profile information will be <b><i>permanently deleted.</i></b></p>
                      <button id="deleteAccountBtn" style="background: #ff4757; color: #fff; border: none; padding: 12px 32px; border-radius: 8px; font-weight: 600; font-size: 1.1rem; cursor: pointer;">Delete Account</button>
                    </div>
                    <!-- Delete Account Modal -->
                    <div id="deleteAccountModal" class="profile-modal-bg">
                      <div class="profile-modal">
                        <div class="modal-icon error"><i class="fas fa-exclamation-triangle"></i></div>
                        <h2>Are you sure?</h2>
                        <p>This action will permanently delete your account and all associated data. This cannot be undone.</p>
                        <form id="deleteAccountForm" action="<%= request.getContextPath() %>/user/profile/delete-account" method="post">
                          <button type="submit" class="modal-btn delete">Yes, Delete</button>
                          <button type="button" id="cancelDeleteAccountBtn" class="modal-btn cancel">Cancel</button>
                        </form>
                      </div>
                    </div>
                </div>
                <div id="profile-bookings-section" class="profile-section-content">
                    <h2 style="margin-bottom:20px;">My Bookings</h2>
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


    <!-- Profile Update Success Modal -->
    <div id="profileSuccessModal" style="display:none;position:fixed;z-index:1000;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;">
      <div style="background:#231818;color:#fff;padding:32px 24px;border-radius:12px;max-width:350px;width:90%;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,0.18);position:relative;">
        <div style="font-size:48px;color:#4BB543;margin-bottom:12px;"><i class="fas fa-check-circle"></i></div>
        <h2 style="margin-bottom:12px;">Profile Updated</h2>
        <p style="margin-bottom:24px;">Your profile has been updated successfully!</p>
        <button onclick="document.getElementById('profileSuccessModal').style.display='none'" style="background:#ff4757;color:#fff;border:none;padding:10px 28px;border-radius:6px;font-weight:500;cursor:pointer;">Close</button>
      </div>
    </div>
    <!-- Booking Cancel Success Modal -->
    <div id="bookingCancelModal" style="display:none;position:fixed;z-index:1000;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;">
      <div style="background:#231818;color:#fff;padding:32px 24px;border-radius:12px;max-width:350px;width:90%;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,0.18);position:relative;">
        <div style="font-size:48px;color:#4BB543;margin-bottom:12px;"><i class="fas fa-check-circle"></i></div>
        <h2 style="margin-bottom:12px;">Booking Cancelled</h2>
        <p style="margin-bottom:24px;">Your booking has been cancelled successfully.</p>
        <button onclick="document.getElementById('bookingCancelModal').style.display='none'" style="background:#ff4757;color:#fff;border:none;padding:10px 28px;border-radius:6px;font-weight:500;cursor:pointer;">Close</button>
      </div>
    </div>
    <!-- Profile Photo Update Success Modal -->
    <div id="profilePhotoSuccessModal" style="display:none;position:fixed;z-index:1000;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;">
      <div style="background:#231818;color:#fff;padding:32px 24px;border-radius:12px;max-width:350px;width:90%;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,0.18);position:relative;">
        <div style="font-size:48px;color:#4BB543;margin-bottom:12px;"><i class="fas fa-check-circle"></i></div>
        <h2 style="margin-bottom:12px;">Profile Photo Updated</h2>
        <p style="margin-bottom:24px;">Your profile photo has been updated successfully!</p>
        <button onclick="document.getElementById('profilePhotoSuccessModal').style.display='none'" style="background:#ff4757;color:#fff;border:none;padding:10px 28px;border-radius:6px;font-weight:500;cursor:pointer;">Close</button>
      </div>
    </div>
    <!-- Hidden form for photo delete -->
    <form id="photoDeleteForm" action="<%= request.getContextPath() %>/user/profile/photo/delete" method="post" class="hidden-form"></form>
    <!-- Modal for delete confirmation -->
    <div id="photoDeleteConfirmModal" class="profile-modal-bg">
      <div class="profile-modal">
        <div class="modal-icon confirm"><i class="fas fa-question-circle"></i></div>
        <h2>Delete Profile Photo?</h2>
        <p>Are you sure you want to delete your profile photo?</p>
        <button id="confirmDeletePhotoBtn" class="modal-btn delete">Delete</button>
        <button id="cancelDeletePhotoBtn" class="modal-btn cancel">Cancel</button>
      </div>
    </div>
    <!-- Modal for delete success -->
    <div id="photoDeleteSuccessModal" class="profile-modal-bg">
      <div class="profile-modal">
        <div class="modal-icon success"><i class="fas fa-check-circle"></i></div>
        <h2>Profile Photo Deleted</h2>
        <p>Your profile photo has been deleted successfully!</p>
        <button onclick="document.getElementById('photoDeleteSuccessModal').style.display='none'" class="modal-btn delete">Close</button>
      </div>
    </div>
    <!-- Modal for photo confirmation -->
    <div id="photoConfirmModal" class="profile-modal-bg">
      <div class="profile-modal">
        <div class="modal-icon confirm"><i class="fas fa-question-circle"></i></div>
        <h2>Confirm Profile Picture?</h2>
        <p>Do you want to set this as your profile photo?</p>
        <button id="confirmPhotoBtn" class="modal-btn confirm">Confirm</button>
        <button id="cancelPhotoBtn" class="modal-btn cancel">Cancel</button>
      </div>
    </div>
    <!-- Modal for photo upload success -->
    <div id="profilePhotoSuccessModal" class="profile-modal-bg">
      <div class="profile-modal">
        <div class="modal-icon success"><i class="fas fa-check-circle"></i></div>
        <h2>Profile Photo Updated</h2>
        <p>Your profile photo has been updated successfully!</p>
        <button onclick="document.getElementById('profilePhotoSuccessModal').style.display='none'" class="modal-btn delete">Close</button>
      </div>
    </div>
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
            if (window.location.search.includes('success=true')) {
                document.getElementById('profileSuccessModal').style.display = 'flex';
                // Remove the success param from the URL after showing the modal (optional, for better UX)
                if (window.history.replaceState) {
                    const url = new URL(window.location);
                    url.searchParams.delete('success');
                    window.history.replaceState({}, document.title, url.pathname + url.search);
                }
            }
            // Booking cancel modal logic
            if (window.location.search.includes('cancel=success')) {
                document.getElementById('bookingCancelModal').style.display = 'flex';
                if (window.history.replaceState) {
                    const url = new URL(window.location);
                    url.searchParams.delete('cancel');
                    window.history.replaceState({}, document.title, url.pathname + url.search);
                }
            }
            // Profile photo update modal
            if (window.location.search.includes('photo=success')) {
                document.getElementById('profilePhotoSuccessModal').style.display = 'flex';
                if (window.history.replaceState) {
                    const url = new URL(window.location);
                    url.searchParams.delete('photo');
                    window.history.replaceState({}, document.title, url.pathname + url.search);
                }
            }
            // On page load, show/hide preview or placeholder based on user.photoUrl
            var photoPreview = document.getElementById('profilePhotoPreview');
            var photoPlaceholder = document.getElementById('profilePhotoPlaceholder');
            if (photoPreview && photoPlaceholder) {
                // Hide placeholder if image loads
                photoPreview.onload = function() {
                    if (photoPreview.naturalWidth > 0 && photoPreview.naturalHeight > 0) {
                        photoPreview.style.display = 'block';
                        photoPlaceholder.style.display = 'none';
                    }
                };
                // Show placeholder if image fails to load
                photoPreview.onerror = function() {
                    photoPreview.style.display = 'none';
                    photoPlaceholder.style.display = 'block';
                };
                // Initial check (in case image is cached)
                if (photoPreview.complete && photoPreview.naturalWidth > 0) {
                    photoPreview.style.display = 'block';
                    photoPlaceholder.style.display = 'none';
                } else if (photoPreview.complete) {
                    photoPreview.style.display = 'none';
                    photoPlaceholder.style.display = 'block';
                }
            }
            // Show delete success modal if needed
            if (window.location.search.includes('photo_deleted=success')) {
                photoDeleteSuccessModal.style.display = 'flex';
                if (window.history.replaceState) {
                    const url = new URL(window.location);
                    url.searchParams.delete('photo_deleted');
                    window.history.replaceState({}, document.title, url.pathname + url.search);
                }
                // Reset preview and placeholder
                if (photoPreview && photoPlaceholder) {
                    photoPreview.src = '';
                    photoPreview.style.display = 'none';
                    photoPlaceholder.style.display = 'block';
                }
            }
            // Delete account modal logic (restored)
            var deleteBtn = document.getElementById('deleteAccountBtn');
            var modal = document.getElementById('deleteAccountModal');
            var cancelBtn = document.getElementById('cancelDeleteAccountBtn');
            if (deleteBtn && modal && cancelBtn) {
                deleteBtn.onclick = function() { modal.style.display = 'flex'; };
                cancelBtn.onclick = function() { modal.style.display = 'none'; };
            }
        });
        // Profile photo preview and modal logic
        const photoInput = document.getElementById('profilePhotoInput');
        const hiddenPhotoInput = document.getElementById('hiddenProfilePhotoInput');
        const photoPreview = document.getElementById('profilePhotoPreview');
        const photoPlaceholder = document.getElementById('profilePhotoPlaceholder');
        const photoConfirmModal = document.getElementById('photoConfirmModal');
        const confirmPhotoBtn = document.getElementById('confirmPhotoBtn');
        const cancelPhotoBtn = document.getElementById('cancelPhotoBtn');
        const photoUploadForm = document.getElementById('photoUploadForm');
        const photoDeleteForm = document.getElementById('photoDeleteForm');
        const photoDeleteConfirmModal = document.getElementById('photoDeleteConfirmModal');
        const confirmDeletePhotoBtn = document.getElementById('confirmDeletePhotoBtn');
        const cancelDeletePhotoBtn = document.getElementById('cancelDeletePhotoBtn');
        const photoDeleteSuccessModal = document.getElementById('photoDeleteSuccessModal');

        if (photoInput) {
            photoInput.addEventListener('change', function(e) {
              const file = e.target.files[0];
              if (file) {
                  // Check file size (5MB limit)
                  if (file.size > 5 * 1024 * 1024) {
                      showErrorPopup('Image size exceeds 5MB limit. Please choose a smaller image.');
                      e.target.value = ''; // Clear the file input
                      return;
                  }

                  // Check file type
                  if (!file.type.startsWith('image/')) {
                      showErrorPopup('Please upload a valid image file.');
                      e.target.value = ''; // Clear the file input
                      return;
                  }

                  // Show preview
                  const reader = new FileReader();
                  reader.onload = function(e) {
                      photoPreview.src = e.target.result;
                      photoPreview.style.display = 'block';
                      photoPlaceholder.style.display = 'none';
                  };
                  reader.readAsDataURL(file);

                  // Show confirmation modal
                  photoConfirmModal.style.display = 'flex';
              }
            });
          }
        if (confirmPhotoBtn) {
          confirmPhotoBtn.onclick = function() {
            photoConfirmModal.style.display = 'none';
            photoUploadForm.submit();
          };
        }
        if (cancelPhotoBtn) {
          cancelPhotoBtn.onclick = function() {
            photoConfirmModal.style.display = 'none';
            photoPreview.src = '';
            photoPreview.style.display = 'none';
            photoPlaceholder.style.display = 'block';
            photoInput.value = '';
            hiddenPhotoInput.value = '';
          };
        }
        if (document.getElementById('deletePhotoBtn')) {
          document.getElementById('deletePhotoBtn').onclick = function() {
            photoDeleteConfirmModal.style.display = 'flex';
          };
        }
        if (confirmDeletePhotoBtn) {
          confirmDeletePhotoBtn.onclick = function() {
            photoDeleteConfirmModal.style.display = 'none';
            photoDeleteForm.submit();
          };
        }
        if (cancelDeletePhotoBtn) {
          cancelDeletePhotoBtn.onclick = function() {
            photoDeleteConfirmModal.style.display = 'none';
          };
        }
    </script>
</body>
</html> 