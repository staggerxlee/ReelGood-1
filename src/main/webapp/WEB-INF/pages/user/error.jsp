<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error - ReelGood</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .error-container {
      max-width: 800px;
      margin: 50px auto;
      padding: 30px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      text-align: center;
    }
    .error-icon {
      font-size: 60px;
      color: #ff4757;
      margin-bottom: 20px;
    }
    .error-title {
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 15px;
      color: #333;
    }
    .error-message {
      font-size: 16px;
      color: #666;
      margin-bottom: 30px;
      max-width: 600px;
      margin-left: auto;
      margin-right: auto;
    }
    .error-details {
      background-color: #f8f9fa;
      padding: 15px;
      border-radius: 5px;
      margin: 20px 0;
      text-align: left;
      overflow-x: auto;
    }
    .btn-home {
      background-color: #ff4757;
      color: white;
      border: none;
      padding: 12px 25px;
      border-radius: 4px;
      font-weight: 500;
      text-decoration: none;
      display: inline-block;
      transition: background-color 0.3s;
    }
    .btn-home:hover {
      background-color: #ff6b81;
    }
  </style>
</head>
<body>
  <jsp:include page="../components/user-navbar.jsp" />
  
  <div class="container">
    <div class="error-container">
      <div class="error-icon">
        <i class="fas fa-exclamation-circle"></i>
      </div>
      <h1 class="error-title">Oops! Something went wrong</h1>
      <p class="error-message">
        <c:choose>
          <c:when test="${not empty error}">
            ${error}
          </c:when>
          <c:otherwise>
            An unexpected error occurred while processing your request. Please try again later.
          </c:otherwise>
        </c:choose>
      </p>
      
      <% if (request.getParameter("debug") != null) { %>
      <div class="error-details">
        <p><strong>Debug Information:</strong></p>
        <c:if test="${not empty pageContext.exception}">
          <p><strong>Exception:</strong> ${pageContext.exception}</p>
          <p><strong>Stack Trace:</strong></p>
          <pre>${pageContext.exception.stackTrace}</pre>
        </c:if>
      </div>
      <% } %>
      
      <a href="<%= request.getContextPath() %>/user/index" class="btn-home">
        <i class="fas fa-home"></i> Return to Homepage
      </a>
    </div>
  </div>

  <jsp:include page="../components/footer.jsp" />
</body>
</html> 