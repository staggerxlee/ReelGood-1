<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ReelGood</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: #f5f5f5; min-height: 100vh; }
        .container { display: flex; min-height: 100vh; }
        .main-content { 
            margin-left: 250px; 
            padding: 30px; 
            flex: 1; 
            background-color: white; 
            border-radius: 15px; 
            margin: 25px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            min-width: 1200px;
        }
        .header
        { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;}
        .header h1 { font-size: 52px; color: #333; font-weight: 600; margin-top:30px;}
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
            gap: 25px; 
            margin-bottom: 40px; 
        }
        .stat-card { 
            background-color: #f1f2f6; 
            padding: 25px; 
            border-radius: 15px; 
            text-align: center;
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card h3 { color: #2f3542; margin-bottom: 15px; font-size: 24px; }
        .stat-card p { font-size: 32px; font-weight: bold; color: #ff4757; }
        .recent-activity { 
            background-color: #f1f2f6; 
            padding: 25px; 
            border-radius: 15px; 
            margin-bottom: 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .activity-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 25px; 
        }
        .activity-header h2 {
            font-size: 32px;
            color: #2f3542;
            font-weight: bold;
        }
        .activity-list { list-style: none; }
        .activity-item { 
            display: flex; 
            align-items: center; 
            padding: 15px; 
            border-bottom: 1px solid #ddd;
            transition: background-color 0.2s;
        }
        .activity-item:hover {
            background-color: #e9ecef;
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon { 
            width: 50px; 
            height: 50px; 
            border-radius: 50%; 
            background-color: #ff4757; 
            color: white; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            margin-right: 20px;
            font-size: 20px;
        }
        .activity-info { flex: 1; }
        .activity-info div:first-child { 
            font-size: 16px; 
            color: #2f3542;
            margin-bottom: 5px;
        }
        .activity-time { color: #666; font-size: 14px; }
        .movie-cards-container { 
            display: flex; 
            gap: 40px; 
            flex-wrap: wrap; 
            justify-content: center; 
        }
        .movie-card { 
            background: #fff; 
            border-radius: 15px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
            width: 280px; 
            padding: 20px; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            position: relative;
            transition: transform 0.2s;
        }
        .movie-card:hover {
            transform: translateY(-5px);
        }
        .movie-card img { 
            width: 160px; 
            height: 240px; 
            object-fit: cover; 
            border-radius: 10px; 
            margin-bottom: 15px; 
            background: #f0f0f0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .movie-card .movie-title { 
            font-size: 20px; 
            font-weight: 600; 
            color: #2f3542; 
            margin-bottom: 8px; 
            text-align: center; 
        }
        .movie-card .movie-genre { 
            font-size: 15px; 
            color: #888; 
            margin-bottom: 6px; 
        }
        .movie-card .movie-duration { 
            font-size: 14px; 
            color: #555; 
            margin-bottom: 6px; 
        }
        .movie-card .movie-status { 
            font-size: 18px; 
            color: #007bff; 
            margin-bottom: 6px; 
            font-weight: bold;
        }
        .movie-card .movie-release { 
            font-size: 14px; 
            color: #555; 
        }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="components/sidebar.jsp" />
        <div class="main-content">
            <div class="header">
                <h1>Hello, ${user.username}</h1>
            </div>
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Users</h3>
                    <p><c:out value="${stats.totalUsers}"/></p>
                </div>
                <div class="stat-card">
                    <h3>Total Movies</h3>
                    <p><c:out value="${stats.totalMovies}"/></p>
                </div>
                <div class="stat-card">
                    <h3>Total Bookings</h3>
                    <p><c:out value="${stats.totalBookings}"/></p>
                </div>
            </div>
            <div class="activity-header">
                    <h2>Recent Bookings</h2>
                </div>
            <!-- Recent Bookings Panel -->
            <div class="recent-activity">
                
                <ul class="activity-list">
                    <c:forEach items="${stats.recentBookings}" var="booking">
                        <li class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-ticket-alt"></i>
                            </div>
                            <div class="activity-info">
                                <div><c:out value="${booking.username}"/> booked <c:out value="${booking.movieTitle}"/></div>
                                <div class="activity-time"><c:out value="${booking.createdAt}"/></div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
             <div class="activity-header">
                    <h2>Recent Movies</h2>
                </div>
            <!-- Recent Movies Card Panel -->
            <div class="recent-activity">
               
                <c:choose>
                    <c:when test="${empty stats.recentMovies}">
                        <div style="color: #888; font-size: 16px; padding: 24px 0; text-align: center;">No recent movies found.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="movie-cards-container">
                            <c:forEach items="${stats.recentMovies}" var="movie">
                                <div class="movie-card">
                                    <img src="${pageContext.request.contextPath}/movie-image?id=${movie.id}" alt="<c:out value='${movie.title}'/>">
                                    <div class="movie-title"><c:out value='${movie.title}'/></div>
                                    <div class="movie-genre"><c:out value='${movie.genre}'/></div>
                                    <div class="movie-duration"><c:out value='${movie.duration}'/> minutes</div>
                                    <div class="movie-status"><c:out value='${movie.status}'/></div>
                                    <div class="movie-release">Release: <c:out value='${movie.releaseDate}'/></div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Top Theaters Panel -->
            <div class="recent-activity">
                <div class="activity-header">
                    <h2>Top Theaters</h2>
                </div>
                <c:choose>
                    <c:when test="${empty stats.topTheaters}">
                        <div style="color: #888; font-size: 16px; padding: 24px 0; text-align: center;">No theater data available.</div>
                    </c:when>
                    <c:otherwise>
                        <ul class="activity-list">
                            <c:forEach items="${stats.topTheaters}" var="theater" varStatus="status">
                                <li class="activity-item">
                                    <div class="activity-icon" style="background-color: ${status.index == 0 ? '#ffd700' : status.index == 1 ? '#c0c0c0' : '#cd7f32'}">
                                        <i class="fas fa-trophy"></i>
                                    </div>
                                    <div class="activity-info">
                                        <div><strong style=" font-size:40px; font-weight:bold;">#${status.index + 1}</strong>
                                        <p style="font-size: 28px;"><c:out value="${theater.location}"/></p></div>
                                        <div class="activity-time">Total Shows: <c:out value="${theater.totalShows}"/></div>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
           
        </div>
    </div>
</body>
</html>
