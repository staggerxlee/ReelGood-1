<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.reelgood.service.MovieService" %>
<%@ page import="com.reelgood.model.MovieModel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    MovieModel editMovie = (MovieModel) request.getAttribute("editMovie");
    Object showEditModalObj = request.getAttribute("showEditModal");
    boolean showEditModal = showEditModalObj != null && Boolean.TRUE.equals(showEditModalObj);
    String posterUrl = "https://via.placeholder.com/135x200?text=Poster";
    if (editMovie != null) {
        posterUrl = request.getContextPath() + "/movie-image?id=" + editMovie.getId();
    }

    int durationInt = 0;
    if (editMovie != null && editMovie.getDuration() != null && !editMovie.getDuration().isEmpty()) {
        try {
            durationInt = Integer.parseInt(editMovie.getDuration());
        } catch (NumberFormatException e) {
            durationInt = 0;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Management - ReelGood Admin</title>
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
            min-height: 90vh;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2f3542;
            font-size: 40px;
            margin-top:40px;
            margin-bottom:40px;
        }

        .add-movie-btn {
            background-color: #ff4757;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 20px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 16px;
        }

        .add-movie-btn:hover {
            background-color: #ff6b81;
        }

        .movie-cards-container {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            margin-top: 32px;
            justify-content: center;
        }
        .movie-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            width: 260px;
            padding: 18px 16px 16px 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
        }
        .movie-card img {
            width: 135px;
            height: 200px;
            object-fit: cover;
            border-radius: 6px;
            margin-bottom: 12px;
            background: #f0f0f0;
        }
        .movie-card .movie-title {
            font-size: 18px;
            font-weight: 600;
            color: #2f3542;
            margin-bottom: 6px;
            text-align: center;
        }
        .movie-card .movie-genre {
            font-size: 14px;
            color: #888;
            margin-bottom: 4px;
        }
        .movie-card .movie-duration {
            font-size: 13px;
            color: #555;
            margin-bottom: 4px;
        }
        .movie-card .movie-status {
            margin-bottom: 8px;
        }
        .movie-card .movie-actions {
            display: flex;
            gap: 10px;
            margin-top: 8px;
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

        /* Success Popup Styles */
        .success-popup {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #2ecc71;
            color: white;
            padding: 15px 25px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: none;
            z-index: 2000;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }

        .success-popup.show {
            display: block;
        }

        .success-popup.hide {
            animation: slideOut 0.3s ease-out forwards;
        }

        .success-popup i {
            margin-right: 8px;
        }

        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 5px;
            display: none;
        }

        .loading.show {
            display: block;
        }

        .loading-spinner {
            width: 30px;
            height: 30px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #ff4757;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal.show {
            display: flex;
        }
        .modal-content {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            width: 100%;
            max-width: 500px;
            max-height: 90vh;
            box-sizing: border-box;
            position: relative;
            overflow-y: auto;
        }
        .poster-preview-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
        }
        .poster-drop-area {
            width: 135px;
            height: 200px;
            border: 2px dashed #aaa;
            border-radius: 6px;
            background: #fafafa;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            cursor: pointer;
            margin-bottom: 8px;
            transition: border-color 0.2s;
            position: relative;
        }
        .poster-drop-area:hover {
            border-color: #ff4757;
        }
        .poster-drop-area input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        .poster-preview {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        .poster-drop-text {
            position: absolute;
            color: #888;
            font-size: 13px;
            text-align: center;
            pointer-events: none;
        }
        .poster-note {
            font-size: 12px;
            color: #888;
            text-align: center;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .close-btn {
            font-size: 24px;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 40px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
        }

        .btn-primary {
            background-color: #333333;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger{
        background-color: red;
            color: white;
        }

        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }

        .status.now-showing {
            background-color: #2ed573;
            color: white;
        }

        .status.coming-soon {
            background-color: #ffa502;
            color: white;
        }

        .status.inactive {
            background-color: #ff4757;
            color: white;
        }

        .rating-group .rating-input-wrapper {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .rating-group input[type="number"] {
            width: 60px;
        }
        .rating-out-of {
            color: #888;
            font-size: 15px;
        }

        /* Confirmation Modal Styles */
        .confirmation-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .confirmation-modal.show {
            display: flex;
        }
        .confirmation-content {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .confirmation-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2f3542;
        }
        .confirmation-message {
            margin-bottom: 30px;
            color: #555;
        }
        .confirmation-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .confirmation-btn {
            padding: 10px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .confirm-delete {
            background-color: #ff4757;
            color: white;
            border: none;
        }
        .confirm-delete:hover {
            background-color: #ff6b81;
        }
        .cancel-delete {
            background-color: #f1f2f6;
            color: #2f3542;
            border: 1px solid #ddd;
        }
        .cancel-delete:hover {
            background-color: #e2e3e7;
        }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="components/sidebar.jsp" />

        <div class="main-content">
            <div class="header">
                <h1>Movie Management</h1>
                <form action="<%= request.getContextPath() %>/admin/movies" method="get" style="display: inline;">
                    <input type="hidden" name="action" value="add">
                    <button type="submit" class="add-movie-btn">Add New Movie</button>
                </form>
            </div>

            <% 
                String errorMessage = (String) request.getAttribute("error");
                String successMessage = request.getParameter("success");
                String error = (String) request.getAttribute("error");
                List<MovieModel> movies = (List<MovieModel>) request.getAttribute("movies");
                if (movies == null) {
                    movies = new ArrayList<>();
                }
                String showAddModal = request.getParameter("action") != null && request.getParameter("action").equals("add") ? "show" : "";
            %>

            <% if (errorMessage != null) { %>
            <div class="error-message" style="position: fixed; top: 32px; left: 50%; transform: translateX(-50%); background: white; color: #ff4757; padding: 18px 36px; border-radius: 10px; box-shadow: 0 4px 24px rgba(0,0,0,0.18); font-size: 1.08rem; z-index: 9999; text-align: center;">
        <i class="fa fa-exclamation-circle" style="margin-right: 8px;"></i>
       <%= errorMessage %>
      </div>
                
            <% } %>

            <% if (successMessage != null) { %>
                <div class="success-message"><%= successMessage %></div>
            <% } %>

            <!-- Success Popup -->
            <div id="successPopup" class="success-popup">
                <i class="fas fa-check-circle"></i>
                <span id="successMessage"></span>
            </div>

            <div class="movie-cards-container">
                <% for (MovieModel movie : movies) { %>
                    <div class="movie-card">
                        <img src="<%= request.getContextPath() %>/movie-image?id=<%= movie.getId() %>" alt="<%= movie.getTitle() %>">
                        <div class="movie-title"><%= movie.getTitle() %></div>
                        <div class="movie-genre"><%= movie.getGenre() %></div>
                        <div class="movie-duration"><%= movie.getDuration() %> minutes</div>
                        <div class="movie-status"><%= movie.getStatus() %></div>
                        <div class="movie-actions">
                            <form action="<%= request.getContextPath() %>/admin/movies" method="get" style="display: inline;">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="<%= movie.getId() %>">
                                <button type="submit" class="btn btn-primary">Edit</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/admin/movies" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= movie.getId() %>">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this movie?')">Delete</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Add Movie Form -->
            <div class="modal <%= showAddModal %>" id="addMovieModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New Movie</h2>
                        <a href="<%= request.getContextPath() %>/admin/movies" class="close-btn">&times;</a>
                    </div>
                    <form action="<%= request.getContextPath() %>/admin/movies" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <div class="poster-preview-container">
                            <label for="poster">
                                <div class="poster-drop-area">
                                    <img id="posterPreview" class="poster-preview" src="https://via.placeholder.com/135x200?text=Poster" alt="Poster Preview">
                                    <div class="poster-drop-text">Click to upload movie poster</div>
                                    <input type="file" id="poster" name="poster" accept="image/*" required onchange="previewPoster(this)">
                                </div>
                            </label>
                            <div class="poster-note">Recommended: 27 × 40 in (2:3 ratio, e.g. 1350×2000 px)</div>
                        </div>
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" required>
                        </div>
                        <div class="form-group">
                            <label for="releaseDate">Release Date</label>
                            <input type="date" id="releaseDate" name="releaseDate" required>
                        </div>
                        <div class="form-group">
                            <label for="duration_hr">Duration</label>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <input type="number" id="duration_hr" name="duration_hr" min="0" value="0" style="width: 60px;"> hr
                                <input type="number" id="duration_min" name="duration_min" min="0" max="59" value="0" style="width: 60px;"> min
                            </div>
                            <input type="hidden" id="duration" name="duration" value="0">
                        </div>
                        <div class="form-group">
                            <label for="genre">Genre</label>
                            <div id="genre-select-container">
                                <select id="genre-select" style="width: 60%;">
                                    <option value="Action">Action</option>
                                    <option value="Comedy">Comedy</option>
                                    <option value="Drama">Drama</option>
                                    <option value="Thriller">Thriller</option>
                                    <option value="Horror">Horror</option>
                                    <option value="Romance">Romance</option>
                                    <option value="Sci-Fi">Sci-Fi</option>
                                    <option value="Animation">Animation</option>
                                    <option value="Adventure">Adventure</option>
                                    <option value="Fantasy">Fantasy</option>
                                    <option value="Documentary">Documentary</option>
                                    <option value="Other">Other</option>
                                </select>
                                <button type="button" id="add-genre-btn" class="btn btn-secondary" style="margin-left: 8px;">Add</button>
                            </div>
                            <div id="selected-genres" style="margin-top: 8px; display: flex; flex-wrap: wrap; gap: 6px;"></div>
                            <input type="hidden" id="genre" name="genre" value="">
                        </div>
                        <div class="form-group">
                            <label for="language">Language</label>
                            <input type="text" id="language" name="language" required>
                        </div>
                        <div class="form-group" id="add-rating-group">
                            <label for="rating">Rating</label>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <input type="number" id="rating" name="rating" min="1" max="10" step="0.1">
                                <span>/10</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" required>
                                <option value="Now Showing">Now Showing</option>
                                <option value="Coming Soon">Coming Soon</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4" style="width: 100%; padding: 8px;"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="cast">Cast</label>
                            <textarea id="cast" name="cast" rows="2" style="width: 100%; padding: 8px;" placeholder="e.g. Actor 1, Actor 2, Actor 3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="director">Director</label>
                            <input type="text" id="director" name="director" placeholder="e.g. Christopher Nolan">
                        </div>
                        <div class="form-actions">
                            <a href="<%= request.getContextPath() %>/admin/movies" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Add Movie</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Edit Movie Form -->
            <div class="modal <%= showEditModal ? "show" : "" %>" id="editMovieModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Edit Movie</h2>
                        <a href="<%= request.getContextPath() %>/admin/movies" class="close-btn">&times;</a>
                    </div>
                    <form action="<%= request.getContextPath() %>/admin/movies" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= editMovie != null ? editMovie.getId() : "" %>">
                        <div class="poster-preview-container">
                            <label for="editPoster">
                                <div class="poster-drop-area">
                                    <img id="editPosterPreview" class="poster-preview" src="<%= posterUrl %>" alt="Poster Preview">
                                    <div class="poster-drop-text">Click to upload movie poster</div>
                                    <input type="file" id="editPoster" name="poster" accept="image/*" onchange="previewEditPoster(this)">
                                </div>
                            </label>
                            <div class="poster-note">Recommended: 27 × 40 in (2:3 ratio, e.g. 1350×2000 px)</div>
                        </div>
                        <div class="form-group">
                            <label for="editTitle">Title</label>
                            <input type="text" id="editTitle" name="title" value="<%= editMovie != null ? editMovie.getTitle() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="editReleaseDate">Release Date</label>
                            <input type="date" id="editReleaseDate" name="releaseDate" value="<%= editMovie != null && editMovie.getReleaseDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(editMovie.getReleaseDate()) : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="editDuration_hr">Duration</label>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <input type="number" id="editDuration_hr" name="duration_hr" min="0" value="<%= durationInt / 60 %>" style="width: 60px;"> hr
                                <input type="number" id="editDuration_min" name="duration_min" min="0" max="59" value="<%= durationInt % 60 %>" style="width: 60px;"> min
                            </div>
                            <input type="hidden" id="editDuration" name="duration" value="<%= editMovie != null ? editMovie.getDuration() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label for="editGenre">Genre</label>
                            <div id="edit-genre-select-container">
                                <select id="edit-genre-select" style="width: 60%;">
                                    <option value="Action" <%= editMovie != null && editMovie.getGenre().contains("Action") ? "selected" : "" %>>Action</option>
                                    <option value="Comedy" <%= editMovie != null && editMovie.getGenre().contains("Comedy") ? "selected" : "" %>>Comedy</option>
                                    <option value="Drama" <%= editMovie != null && editMovie.getGenre().contains("Drama") ? "selected" : "" %>>Drama</option>
                                    <option value="Thriller" <%= editMovie != null && editMovie.getGenre().contains("Thriller") ? "selected" : "" %>>Thriller</option>
                                    <option value="Horror" <%= editMovie != null && editMovie.getGenre().contains("Horror") ? "selected" : "" %>>Horror</option>
                                    <option value="Romance" <%= editMovie != null && editMovie.getGenre().contains("Romance") ? "selected" : "" %>>Romance</option>
                                    <option value="Sci-Fi" <%= editMovie != null && editMovie.getGenre().contains("Sci-Fi") ? "selected" : "" %>>Sci-Fi</option>
                                    <option value="Animation" <%= editMovie != null && editMovie.getGenre().contains("Animation") ? "selected" : "" %>>Animation</option>
                                    <option value="Adventure" <%= editMovie != null && editMovie.getGenre().contains("Adventure") ? "selected" : "" %>>Adventure</option>
                                    <option value="Fantasy" <%= editMovie != null && editMovie.getGenre().contains("Fantasy") ? "selected" : "" %>>Fantasy</option>
                                    <option value="Documentary" <%= editMovie != null && editMovie.getGenre().contains("Documentary") ? "selected" : "" %>>Documentary</option>
                                    <option value="Other" <%= editMovie != null && !editMovie.getGenre().contains("Action") && !editMovie.getGenre().contains("Comedy") && !editMovie.getGenre().contains("Drama") && !editMovie.getGenre().contains("Thriller") && !editMovie.getGenre().contains("Horror") && !editMovie.getGenre().contains("Romance") && !editMovie.getGenre().contains("Sci-Fi") && !editMovie.getGenre().contains("Animation") && !editMovie.getGenre().contains("Adventure") && !editMovie.getGenre().contains("Fantasy") && !editMovie.getGenre().contains("Documentary") ? "selected" : "" %>>Other</option>
                                </select>
                                <button type="button" id="edit-add-genre-btn" class="btn btn-secondary" style="margin-left: 8px;">Add</button>
                            </div>
                            <div id="edit-selected-genres" style="margin-top: 8px; display: flex; flex-wrap: wrap; gap: 6px;"></div>
                            <input type="hidden" id="editGenre" name="genre" value="<%= editMovie != null ? editMovie.getGenre() : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="editLanguage">Language</label>
                            <input type="text" id="editLanguage" name="language" value="<%= editMovie != null ? editMovie.getLanguage() : "" %>" required>
                        </div>
                        <div class="form-group" id="edit-rating-group">
                            <label for="editRating">Rating</label>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <input type="number" id="editRating" name="rating" min="1" max="10" step="0.1" value="<%= editMovie != null ? editMovie.getRating() : "" %>">
                                <span>/10</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="editStatus">Status</label>
                            <select id="editStatus" name="status" required>
                                <option value="Now Showing" <%= editMovie != null && "Now Showing".equals(editMovie.getStatus()) ? "selected" : "" %>>Now Showing</option>
                                <option value="Coming Soon" <%= editMovie != null && "Coming Soon".equals(editMovie.getStatus()) ? "selected" : "" %>>Coming Soon</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editDescription">Description</label>
                            <textarea id="editDescription" name="description" rows="4" style="width: 100%; padding: 8px;"><%= editMovie != null && editMovie.getDescription() != null ? editMovie.getDescription() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="editCast">Cast</label>
                            <textarea id="editCast" name="cast" rows="2" style="width: 100%; padding: 8px;" placeholder="e.g. Actor 1, Actor 2, Actor 3"><%= editMovie != null && editMovie.getCast() != null ? editMovie.getCast() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="editDirector">Director</label>
                            <input type="text" id="editDirector" name="director" placeholder="e.g. Christopher Nolan" value="<%= editMovie != null && editMovie.getDirector() != null ? editMovie.getDirector() : "" %>">
                        </div>
                        <div class="form-actions">
                            <a href="<%= request.getContextPath() %>/admin/movies" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Update Movie</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        var editPosterUrl = "<%= posterUrl %>";

        function previewPoster(input) {
            const preview = document.getElementById('posterPreview');
            const dropText = document.querySelector('.poster-drop-text');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    dropText.style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.src = 'https://via.placeholder.com/135x200?text=Poster';
                dropText.style.display = 'block';
            }
        }

        function previewEditPoster(input) {
            const preview = document.getElementById('editPosterPreview');
            const dropText = document.querySelector('#editMovieModal .poster-drop-text');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    dropText.style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.src = editPosterUrl;
                dropText.style.display = 'block';
            }
        }

        // Combine hr/min into duration (minutes) before submit
        const addMovieForm = document.querySelector('#addMovieModal form');
        if (addMovieForm) {
            addMovieForm.addEventListener('submit', function(e) {
                const hr = parseInt(document.getElementById('duration_hr').value) || 0;
                const min = parseInt(document.getElementById('duration_min').value) || 0;
                document.getElementById('duration').value = (hr * 60) + min;
                // Fix: If Coming Soon, clear rating and not required
                const status = document.getElementById('status').value;
                const ratingInput = document.getElementById('rating');
                if (status === 'Coming Soon') {
                    ratingInput.value = '';
                    ratingInput.required = false;
                }
            });
        }

        // Genre multi-select logic
        const genreSelect = document.getElementById('genre-select');
        const addGenreBtn = document.getElementById('add-genre-btn');
        const selectedGenresDiv = document.getElementById('selected-genres');
        const genreInput = document.getElementById('genre');
        let selectedGenres = [];

        function updateGenreInput() {
            genreInput.value = selectedGenres.join(',');
        }

        function renderSelectedGenres() {
            selectedGenresDiv.innerHTML = '';
            selectedGenres.forEach((genre, idx) => {
                const tag = document.createElement('span');
                tag.textContent = genre;
                tag.className = 'genre-tag';
                tag.style = 'background:#eee;padding:4px 10px;border-radius:12px;margin-right:4px;display:inline-flex;align-items:center;gap:4px;';
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.textContent = '×';
                removeBtn.style = 'background:none;border:none;color:#ff4757;font-size:14px;cursor:pointer;';
                removeBtn.onclick = () => {
                    selectedGenres.splice(idx, 1);
                    renderSelectedGenres();
                    updateGenreInput();
                };
                tag.appendChild(removeBtn);
                selectedGenresDiv.appendChild(tag);
            });
            updateGenreInput();
        }

        addGenreBtn.onclick = function() {
            const genre = genreSelect.value;
            if (genre && !selectedGenres.includes(genre)) {
                selectedGenres.push(genre);
                renderSelectedGenres();
            }
        };

        // Genre multi-select logic for edit form
        const editGenreSelect = document.getElementById('edit-genre-select');
        const editAddGenreBtn = document.getElementById('edit-add-genre-btn');
        const editSelectedGenresDiv = document.getElementById('edit-selected-genres');
        const editGenreInput = document.getElementById('editGenre');
        let editSelectedGenres = [];

        // Initialize editSelectedGenres from the hidden input value
        if (editGenreInput && editGenreInput.value) {
            editSelectedGenres = editGenreInput.value.split(',').map(g => g.trim()).filter(g => g);
        }

        function updateEditGenreInput() {
            editGenreInput.value = editSelectedGenres.join(',');
        }

        function renderEditSelectedGenres() {
            editSelectedGenresDiv.innerHTML = '';
            editSelectedGenres.forEach((genre, idx) => {
                const tag = document.createElement('span');
                tag.textContent = genre;
                tag.className = 'genre-tag';
                tag.style = 'background:#eee;padding:4px 10px;border-radius:12px;margin-right:4px;display:inline-flex;align-items:center;gap:4px;';
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.textContent = '×';
                removeBtn.style = 'background:none;border:none;color:#ff4757;font-size:14px;cursor:pointer;';
                removeBtn.onclick = () => {
                    editSelectedGenres.splice(idx, 1);
                    renderEditSelectedGenres();
                    updateEditGenreInput();
                };
                tag.appendChild(removeBtn);
                editSelectedGenresDiv.appendChild(tag);
            });
            updateEditGenreInput();
        }

        if (editAddGenreBtn) {
            editAddGenreBtn.onclick = function() {
                const genre = editGenreSelect.value;
                if (genre && !editSelectedGenres.includes(genre)) {
                    editSelectedGenres.push(genre);
                    renderEditSelectedGenres();
                }
            };
        }

        // Render on page load if editing
        if (editSelectedGenresDiv) {
            renderEditSelectedGenres();
        }

        // Combine hr/min into duration (minutes) before submit for edit form
        const editMovieForm = document.querySelector('#editMovieModal form');
        if (editMovieForm) {
            editMovieForm.addEventListener('submit', function(e) {
                const hr = parseInt(document.getElementById('editDuration_hr').value) || 0;
                const min = parseInt(document.getElementById('editDuration_min').value) || 0;
                document.getElementById('editDuration').value = (hr * 60) + min;
                // Fix: If Coming Soon, clear rating and not required
                const status = document.getElementById('editStatus').value;
                const ratingInput = document.getElementById('editRating');
                if (status === 'Coming Soon') {
                    ratingInput.value = '';
                    ratingInput.required = false;
                }
            });
        }

        // Hide rating field if status is Coming Soon (Add form)
        const statusSelect = document.getElementById('status');
        const ratingGroup = document.getElementById('add-rating-group');
        function toggleRatingField() {
            if (statusSelect.value === 'Coming Soon') {
                ratingGroup.style.display = 'none';
                document.getElementById('rating').required = false;
            } else {
                ratingGroup.style.display = '';
                document.getElementById('rating').required = true;
            }
        }
        if (statusSelect && ratingGroup) {
            statusSelect.addEventListener('change', toggleRatingField);
            toggleRatingField();
        }
        // Hide rating field if status is Coming Soon (Edit form)
        const editStatusSelect = document.getElementById('editStatus');
        const editRatingGroup = document.getElementById('edit-rating-group');
        function toggleEditRatingField() {
            if (editStatusSelect.value === 'Coming Soon') {
                editRatingGroup.style.display = 'none';
                document.getElementById('editRating').required = false;
            } else {
                editRatingGroup.style.display = '';
                document.getElementById('editRating').required = true;
            }
        }
        if (editStatusSelect && editRatingGroup) {
            editStatusSelect.addEventListener('change', toggleEditRatingField);
            toggleEditRatingField();
        }

        // Show success popup
        function showSuccessPopup(message) {
            const popup = document.getElementById('successPopup');
            const messageSpan = document.getElementById('successMessage');
            messageSpan.textContent = message;
            popup.classList.add('show');
            
            // Hide popup after 3 seconds
            setTimeout(() => {
                popup.classList.add('hide');
                setTimeout(() => {
                    popup.classList.remove('show', 'hide');
                }, 300);
            }, 3000);
        }

        // Check for success parameter in URL
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('success');
        if (successMessage) {
            showSuccessPopup(successMessage);
            // Remove the success parameter from URL without refreshing
            const newUrl = window.location.pathname + window.location.search.replace(/[?&]success=[^&]+/, '');
            window.history.replaceState({}, '', newUrl);
        }
    </script>
</body>
</html>
