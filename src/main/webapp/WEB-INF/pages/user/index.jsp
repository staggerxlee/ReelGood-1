<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="user-navbar.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReelGood - Home</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
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
      border-radius: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.08);
      width: 260px;
      padding: 18px 16px 16px 16px;
      display: flex;
      flex-direction: column;
      align-items: center;
      position: relative;;
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
    .coming-soon-carousel {
      text-align: center;
      margin: 40px auto 0 auto;
      max-width: 500px;
    }
    .carousel-container {
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }
    .carousel-slide {
      width: 300px;
      min-height: 400px;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
    }
    .carousel-item {
      display: block;
      transition: opacity 0.5s;
    }
    .carousel-item img {
      width: 220px;
      height: 330px;
      border-radius: 12px;
      box-shadow: 0 4px 24px rgba(0,0,0,0.15);
    }
    .carousel-title {
      font-size: 1.3rem;
      font-weight: bold;
      margin-top: 12px;
      color: #fff;
    }
    .carousel-genre {
      color: #eee;
      margin-top: 4px;
    }
    .carousel-arrow {
      background: #b71c1c;
      color: #fff;
      border: none;
      font-size: 2rem;
      border-radius: 50%;
      width: 44px;
      height: 44px;
      cursor: pointer;
      margin: 0 10px;
      transition: background 0.2s;
    }
    .carousel-arrow:hover {
      background: #d32f2f;
    }
    .carousel-dots {
      margin-top: 16px;
    }
    .carousel-dots .dot {
      display: inline-block;
      width: 12px;
      height: 12px;
      margin: 0 4px;
      background: #fff;
      border-radius: 50%;
      opacity: 0.5;
      cursor: pointer;
      transition: opacity 0.2s, background 0.2s;
    }
    .carousel-dots .dot.active {
      opacity: 1;
      background: #b71c1c;
    }
    .carousel-rating {
      color: #ffcc00;
      font-weight: bold;
      margin-top: 8px;
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Coming Soon Carousel (Slideshow) -->
    <div class="coming-soon-carousel">
      <h2 class="slideshow-title">Coming Soon</h2>
      <div class="carousel-container">
        <button class="carousel-arrow left" onclick="moveSlide(-1)">&#8249;</button>
        <div class="carousel-slide">
          <c:forEach var="movie" items="${comingSoonMovies}" varStatus="status">
            <c:if test="${status.index lt 5}">
              <c:choose>
                <c:when test="${status.index eq 0}">
                  <div class="carousel-item">
                    <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}" />
                    <div class="carousel-title">${movie.title}</div>
                    <div class="carousel-genre">${movie.genre}</div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="carousel-item" style="display:none;">
                    <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}" />
                    <div class="carousel-title">${movie.title}</div>
                    <div class="carousel-genre">${movie.genre}</div>
                  </div>
                </c:otherwise>
              </c:choose>
            </c:if>
          </c:forEach>
        </div>
        <button class="carousel-arrow right" onclick="moveSlide(1)">&#8250;</button>
      </div>
      <div class="carousel-dots">
        <c:forEach var="movie" items="${comingSoonMovies}" varStatus="status">
          <c:if test="${status.index lt 5}">
            <c:choose>
              <c:when test="${status.index eq 0}">
                <span class="dot active" onclick="showSlide(<c:out value='${status.index}'/>)"></span>
              </c:when>
              <c:otherwise>
                <span class="dot" onclick="showSlide(<c:out value='${status.index}'/>)"></span>
              </c:otherwise>
            </c:choose>
          </c:if>
        </c:forEach>
      </div>
    </div>

    <!-- TABS: Now Showing / Coming Soon -->
    <div class="tabs">
      <div class="tabs-list">
        <button class="tab-trigger active" data-tab="now-showing" onclick="showTab('now-showing')">Now Showing</button>
        <button class="tab-trigger" data-tab="coming-soon" onclick="showTab('coming-soon')">Coming Soon</button>
      </div>
      <div class="tab-content active" id="now-showing">
        <div class="movie-grid">
          <c:forEach var="movie" items="${nowShowingMovies}">
            <div class="movie-card">
            <span class="movie-rating">${movie.rating}/10</span>
              <div class="movie-poster">
                <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}">
                
              </div>
              <div class="movie-info">
                <h3 class="movie-title">${movie.title}</h3>
                <div class="movie-meta">
                  <span class="movie-duration">${movie.duration} min</span>
                  <span class="separator">•</span>
                  <span class="movie-genre">${movie.genre}</span>
                </div>
                <a href="<%= request.getContextPath() %>/user/movie-details?movieId=${movie.id}" class="btn btn-primary book-btn">View Details</a>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
      <div class="tab-content" id="coming-soon">
        <div class="movie-grid">
          <c:forEach var="movie" items="${comingSoonMovies}">
            <div class="movie-card">
              <div class="movie-poster">
                <img src="<%= request.getContextPath() %>/movie-image?id=${movie.id}" alt="${movie.title}">
                <div class="coming-soon-badge">Coming Soon</div>
              </div>
              <div class="movie-info">
                <h3 class="movie-title">${movie.title}</h3>
                <div class="movie-meta">
                  <span class="movie-duration">${movie.duration} min</span>
                  <span class="separator">•</span>
                  <span class="movie-genre">${movie.genre}</span>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="user-footer.jsp" />

  <script src="<%= request.getContextPath() %>/js/main.js"></script>
  <script>
    function showTab(tab) {
      document.querySelectorAll('.tab-trigger').forEach(btn => {
        btn.classList.toggle('active', btn.getAttribute('data-tab') === tab);
      });
      document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.toggle('active', content.id === tab);
      });
    }
    document.addEventListener('DOMContentLoaded', function() {
      showTab('now-showing');
    });

    let currentSlide = 0;
    function showSlide(n) {
      const slides = document.querySelectorAll('.carousel-item');
      const dots = document.querySelectorAll('.carousel-dots .dot');
      if (!slides.length) return;
      currentSlide = (n + slides.length) % slides.length;
      slides.forEach((slide, i) => {
        slide.style.display = (i === currentSlide) ? 'block' : 'none';
      });
      dots.forEach((dot, i) => {
        dot.classList.toggle('active', i === currentSlide);
      });
    }
    function moveSlide(dir) {
      showSlide(currentSlide + dir);
    }
    document.addEventListener('DOMContentLoaded', () => showSlide(0));
  </script>
</body>
</html> 