<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Support - ReelGood</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newcss/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newcss/admin-sidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
  
        .admin-support-container {
            display: flex;
            min-height: 100vh;
        }
        .admin-support-main {
            flex: 1;
            padding: 2.5rem 2rem;
            background: #f5f6fa;
            color: #222;
        }
        .support-header {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #222;
        }
        .support-card {
            background: #fff;
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .support-card h2 {
            color: #c00;
            margin-bottom: 1rem;
        }
        .support-links {
            margin-top: 2rem;
        }
        .support-links a {
            display: inline-block;
            margin-right: 1.5rem;
            color: #c00;
            font-weight: 600;
            text-decoration: none;
            font-size: 1.1rem;
            transition: color 0.2s;
        }
        .support-links a:hover {
            color: #222;
            text-decoration: underline;
        }
        .contact-table {
            width: 100%;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
            border-collapse: collapse;
        }
        .contact-table th, .contact-table td {
            padding: 10px 8px;
            border-bottom: 1px solid #e0e0e0;
            color: #222;
            text-align: left;
            font-size: 15px;
        }
        .contact-table th {
            background: #f5f6fa;
            font-weight: 700;
        }
        .contact-table tr:last-child td {
            border-bottom: none;
        }
        .contact-table td {
            max-width: 320px;
            word-break: break-word;
        }
    </style>
</head>
<body>
<div class="admin-support-container">
    <jsp:include page="components/sidebar.jsp" />
    <div class="admin-support-main">
        <div class="support-header"><i class="fas fa-headset"></i> Admin Support</div>
        <div class="support-card">
            <h2>Need Help?</h2>
            <p>If you have any issues or questions regarding the admin panel, please contact the technical team at <b>reelgood.admin.support@gmail.com</b> or call <b>9800000000</b>.</p>
            <p>For urgent matters, please reach out to the system administrator directly.</p>
        </div>
        <div class="support-card">
            <h2>Contact Messages</h2>
            <table class="contact-table">
                <thead>
                    <tr>
                        <th>ContactMessageID</th>
                        <th>UserID</th>
                        <th>Email</th>
                        <th style="min-width: 350px; max-width: 600px;">Message</th>
                        <th>CreatedAt</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    com.reelgood.service.ContactMessageService contactService = new com.reelgood.service.ContactMessageService();
                    java.util.List<com.reelgood.model.ContactMessageModel> messages = null;
                    try {
                        messages = contactService.getAllMessages();
                    } catch (Exception e) {
                        messages = new java.util.ArrayList<>();
                    }
                %>
                <% for (com.reelgood.model.ContactMessageModel msg : messages) { %>
                    <tr>
                        <td><%= msg.getContactMessageId() %></td>
                        <td><%= msg.getUserId() != null ? msg.getUserId() : "-" %></td>
                        <td><%= msg.getEmail() %></td>
                        <td>
                            <div style="max-height: 120px; min-height: 60px; overflow-y: auto; background: #f9f9f9; border-radius: 6px; padding: 8px; font-size: 15px; white-space: pre-wrap; word-break: break-word;">
                                <%= msg.getMessage() %>
                            </div>
                        </td>
                        <td><%= msg.getCreatedAt() %></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/contact" style="display:inline;">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= msg.getContactMessageId() %>" />
                                <button type="submit" onclick="return confirm('Delete this message?')" style="background:#ff4d4f;color:#fff;border:none;padding:6px 12px;border-radius:5px;cursor:pointer;">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html> 