<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Object showAddModalObj = request.getAttribute("showAddModal");
    boolean showAddModal = showAddModalObj != null && Boolean.TRUE.equals(showAddModalObj);
    
    Object showEditModalObj = request.getAttribute("showEditModal");
    boolean showEditModal = showEditModalObj != null && Boolean.TRUE.equals(showEditModalObj);
    
    com.reelgood.model.ScheduleModel editSchedule = (com.reelgood.model.ScheduleModel) request.getAttribute("editSchedule");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Management - ReelGood Admin</title>
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

        .add-schedule-btn {
            background-color: #ff4757;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-weight: 500;
        }

        .add-schedule-btn:hover {
            background-color: #ff6b81;
        }

        .schedules-container {
            margin-top: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f1f2f6;
            color: #2f3542;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f9f9f9;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0069d9;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .success-message {
            color: #28a745;
            background-color: #d4edda;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow: auto;
        }

        .modal.show {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: white;
            margin: auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            width: 500px;
            max-width: 90%;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }

        .modal-header h2 {
            color: #2f3542;
            font-size: 20px;
            font-weight: 600;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: #666;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .required {
            color: #dc3545;
            margin-left: 3px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .form-actions button {
            padding: 8px 16px;
        }

        .btn-submit {
            background-color: #ff4757;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-cancel {
            background-color: #f1f2f6;
            color: #2f3542;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="components/sidebar.jsp" />
        
        <div class="main-content">
            <div class="header">
                <h1>Movie Schedule Management</h1>
                <form action="<%= request.getContextPath() %>/admin/schedules" method="get">
                    <input type="hidden" name="action" value="add">
                    <button type="submit" class="add-schedule-btn">Add New Schedule</button>
                </form>
            </div>
            
            <!-- Success/Error Messages -->
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
            
            <!-- Schedules Table -->
            <div class="schedules-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Movie</th>
                            <th>Theater Location</th>
                            <th>Show Day</th>
                            <th>Show Time</th>
                            <th>Price</th>
                            <th>Hall Number</th>
                            <th>Language/Format</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="schedule" items="${schedules}">
                            <tr>
                                <td>${schedule.scheduleId}</td>
                                <td>${schedule.movieTitle}</td>
                                <td>${schedule.theaterLocation}</td>
                                <td>${schedule.showDay}</td>
                                <td>${schedule.formattedTime}</td>
                                <td>${schedule.formattedPrice}</td>
                                <td>${schedule.hallNumber}</td>
                                <td>${schedule.languageFormat}</td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/admin/schedules" method="get" style="display: inline;">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="id" value="${schedule.scheduleId}">
                                        <button type="submit" class="btn btn-primary">Edit</button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/admin/schedules" method="get" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${schedule.scheduleId}">
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this schedule?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Add Schedule Modal -->
            <div class="modal <%= showAddModal ? "show" : "" %>" id="addScheduleModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New Schedule</h2>
                        <button class="close-btn">&times;</button>
                    </div>
                    <form action="<%= request.getContextPath() %>/admin/schedules" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-group">
                            <label for="movieId">Movie<span class="required">*</span></label>
                            <select id="movieId" name="movieId" required>
                                <option value="">Select Movie</option>
                                <c:forEach var="movie" items="${movies}">
                                    <option value="${movie.id}">${movie.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="theaterLocation">Theater Location<span class="required">*</span></label>
                            <input type="text" id="theaterLocation" name="theaterLocation" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="showDay">Show Day<span class="required">*</span></label>
                            <select id="showDay" name="showDay" required>
                                <option value="">Select Day</option>
                                <option value="Today">Today</option>
                                <option value="Tomorrow">Tomorrow</option>
                                <option value="Day After">Day After</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="showTime">Show Time<span class="required">*</span></label>
                            <input type="time" id="showTime" name="showTime" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="pricePerSeat">Price Per Seat<span class="required">*</span></label>
                            <input type="number" id="pricePerSeat" name="pricePerSeat" step="0.01" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="hallNumber">Hall Number</label>
                            <input type="text" id="hallNumber" name="hallNumber">
                        </div>
                        
                        <div class="form-group">
                            <label for="languageFormat">Language/Format</label>
                            <select id="languageFormat" name="languageFormat">
                                <option value="">Select Format</option>
                                <option value="English (2D)">English (2D)</option>
                                <option value="English (3D)">English (3D)</option>
                                <option value="Hindi (2D)">Hindi (2D)</option>
                                <option value="Hindi (3D)">Hindi (3D)</option>
                                <option value="Tamil (2D)">Tamil (2D)</option>
                                <option value="Tamil (3D)">Tamil (3D)</option>
                                <option value="Telugu (2D)">Telugu (2D)</option>
                                <option value="Telugu (3D)">Telugu (3D)</option>
                            </select>
                        </div>
                        
                        <div class="form-actions">
                            <a href="<%= request.getContextPath() %>/admin/schedules" class="btn btn-cancel">Cancel</a>
                            <button type="submit" class="btn btn-submit">Add Schedule</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Edit Schedule Modal -->
            <div class="modal <%= showEditModal ? "show" : "" %>" id="editScheduleModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Edit Schedule</h2>
                        <button class="close-btn">&times;</button>
                    </div>
                    <form action="<%= request.getContextPath() %>/admin/schedules" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="scheduleId" value="<%= editSchedule != null ? editSchedule.getScheduleId() : "" %>">
                        
                        <div class="form-group">
                            <label for="editMovieId">Movie<span class="required">*</span></label>
                            <select id="editMovieId" name="movieId" required>
                                <option value="">Select Movie</option>
                                <c:forEach var="movie" items="${movies}">
                                    <option value="${movie.id}" ${editSchedule != null && editSchedule.getMovieId() == movie.id ? 'selected' : ''}>${movie.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="editTheaterLocation">Theater Location<span class="required">*</span></label>
                            <input type="text" id="editTheaterLocation" name="theaterLocation" value="<%= editSchedule != null ? editSchedule.getTheaterLocation() : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editShowDay">Show Day<span class="required">*</span></label>
                            <select id="editShowDay" name="showDay" required>
                                <option value="">Select Day</option>
                                <option value="Today" <%= editSchedule != null && "Today".equals(editSchedule.getShowDay()) ? "selected" : "" %>>Today</option>
                                <option value="Tomorrow" <%= editSchedule != null && "Tomorrow".equals(editSchedule.getShowDay()) ? "selected" : "" %>>Tomorrow</option>
                                <option value="Day After" <%= editSchedule != null && "Day After".equals(editSchedule.getShowDay()) ? "selected" : "" %>>Day After</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="editShowTime">Show Time<span class="required">*</span></label>
                            <input type="time" id="editShowTime" name="showTime" value="<%= editSchedule != null && editSchedule.getShowTime() != null ? editSchedule.getShowTime().toString().substring(0, 5) : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editPricePerSeat">Price Per Seat<span class="required">*</span></label>
                            <input type="number" id="editPricePerSeat" name="pricePerSeat" step="0.01" min="0" value="<%= editSchedule != null && editSchedule.getPricePerSeat() != null ? editSchedule.getPricePerSeat() : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editHallNumber">Hall Number</label>
                            <input type="text" id="editHallNumber" name="hallNumber" value="<%= editSchedule != null ? editSchedule.getHallNumber() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="editLanguageFormat">Language/Format</label>
                            <select id="editLanguageFormat" name="languageFormat">
                                <option value="">Select Format</option>
                                <option value="English (2D)" <%= editSchedule != null && "English (2D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>English (2D)</option>
                                <option value="English (3D)" <%= editSchedule != null && "English (3D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>English (3D)</option>
                                <option value="Hindi (2D)" <%= editSchedule != null && "Hindi (2D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Hindi (2D)</option>
                                <option value="Hindi (3D)" <%= editSchedule != null && "Hindi (3D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Hindi (3D)</option>
                                <option value="Tamil (2D)" <%= editSchedule != null && "Tamil (2D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Tamil (2D)</option>
                                <option value="Tamil (3D)" <%= editSchedule != null && "Tamil (3D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Tamil (3D)</option>
                                <option value="Telugu (2D)" <%= editSchedule != null && "Telugu (2D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Telugu (2D)</option>
                                <option value="Telugu (3D)" <%= editSchedule != null && "Telugu (3D)".equals(editSchedule.getLanguageFormat()) ? "selected" : "" %>>Telugu (3D)</option>
                            </select>
                        </div>
                        
                        <div class="form-actions">
                            <a href="<%= request.getContextPath() %>/admin/schedules" class="btn btn-cancel">Cancel</a>
                            <button type="submit" class="btn btn-submit">Update Schedule</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Delete Warning Modal -->
            <% if (request.getAttribute("deleteWarning") != null && (Boolean)request.getAttribute("deleteWarning")) { %>
                <div class="modal show" id="deleteWarningModal" style="display: flex;">
                    <div class="modal-content" style="max-width: 400px; text-align: center;">
                        <div class="modal-header">
                            <h2>Warning</h2>
                        </div>
                        <div style="margin-bottom: 20px; color: #dc3545;">
                            This schedule has bookings. Deleting it will also delete all related bookings.<br>Are you sure you want to proceed?
                        </div>
                        <form id="confirmDeleteForm" action="<%= request.getContextPath() %>/admin/schedules" method="get" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= request.getAttribute("deleteScheduleId") %>">
                            <input type="hidden" name="confirmDeleteBookings" value="true">
                            <button type="submit" class="btn btn-danger">Yes, Delete All</button>
                            <a href="<%= request.getContextPath() %>/admin/schedules" class="btn btn-cancel" style="margin-left: 10px;">Cancel</a>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        // Close modal when close button is clicked
        document.querySelectorAll('.close-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.modal').forEach(modal => {
                    modal.classList.remove('show');
                });
                window.location.href = "<%= request.getContextPath() %>/admin/schedules";
            });
        });
        
        // Close modal when clicking outside content area
        document.querySelectorAll('.modal').forEach(modal => {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.classList.remove('show');
                    window.location.href = "<%= request.getContextPath() %>/admin/schedules";
                }
            });
        });
    </script>
</body>
</html>