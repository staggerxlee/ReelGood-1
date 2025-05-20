<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - ReelGood Admin</title>
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

        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .user-table th,
        .user-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .user-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #2f3542;
        }

        .user-table tr:hover {
            background-color: #f8f9fa;
        }

        .user-role {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .role-admin {
            background-color: #ff4757;
            color: white;
        }

        .role-user {
            background-color: #2ed573;
            color: white;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
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

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-icon {
            padding: 6px;
            border-radius: 4px;
            background: none;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-icon:hover {
            background-color: #f8f9fa;
        }

        .btn-icon.edit {
            color: #3498db;
        }

        .btn-icon.delete {
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="components/sidebar.jsp" />

        <div class="main-content">
            <div class="header">
                <h1>User Management</h1>
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

            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Gender</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td>${user.userID}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>${user.address}</td>
                            <td>${user.gender}</td>
                            <td>
                                <span class="user-role ${user.role == '2' ? 'role-admin' : 'role-user'}">
                                    ${user.role == '2' ? 'Admin' : 'User'}
                                </span>
                            </td>
                            <td class="action-buttons">
                                <c:if test="${user.role != '2'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline;">
                                        <input type="hidden" name="action" value="promote" />
                                        <input type="hidden" name="userId" value="${user.userID}" />
                                        <button type="submit" class="btn btn-primary" onclick="return confirm('Promote this user to admin?')">Promote</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html> 