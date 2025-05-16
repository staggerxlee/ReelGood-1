<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReelGood - Movies</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
    /* Only keep page-specific styles here. Remove any .user-navbar, .navbar-content, .nav-link, .icon-user, etc. */
    /* Example: movie grid, movie card, etc. */
    .movie-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 24px;
      margin-top: 24px;
      justify-content: center;
    }
    .movie-card {
      background: #231818;
      color: #fff;
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
      color: #fff;
      margin-bottom: 6px;
      text-align: center;
    }
    .movie-card .movie-genre {
      font-size: 14px;
      color: #e0e0e0;
      margin-bottom: 4px;
    }
    .movie-card .movie-duration {
      font-size: 13px;
      color: #e0e0e0;
      margin-bottom: 4px;
    }
    .movie-card .movie-status {
      margin-bottom: 8px;
      color: #fff;
    }
    .movie-card .movie-actions {
      display: flex;
      gap: 10px;
      margin-top: 8px;
    }
    .movie-card .movie-rating {
      position: absolute;
      top: 12px;
      right: 12px;
      background: #ffcc00;
      color: #222;
      font-weight: bold;
      border-radius: 50%;
      width: 38px;
      height: 38px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 15px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .coming-soon-badge {
      position: absolute;
      top: 18px;
      left: 18px;
      background: #ff4757;
      color: white;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
  <jsp:include page="user-navbar.jsp" />
  <div class="container">
    <h1 style="text-align:center; margin-top: 24px;">All Movies</h1>
    <div class="movie-grid">
      <c:forEach var="movie" items="${movies}">
        <div class="movie-card">
          <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}">
          <c:if test="${movie.status eq 'Coming Soon'}">
            <div class="coming-soon-badge">Coming Soon</div>
          </c:if>
          <div class="movie-title">${movie.title}</div>
          <div class="movie-genre">${movie.genre}</div>
          <div class="movie-duration">${movie.duration} min</div>
          <div class="movie-status">${movie.status}</div>
          <c:if test="${movie.status ne 'Coming Soon'}">
            <div class="movie-rating">${movie.rating}/10</div>
            <div class="movie-actions">
            <a href="<%= request.getContextPath() %>/user/movie-details?movieId=${movie.id}" class="btn btn-primary">View Details</a>
            </div>
          </c:if>
        </div>
      </c:forEach>
    </div>
  </div>
  <jsp:include page="user-footer.jsp" />
  <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html> 