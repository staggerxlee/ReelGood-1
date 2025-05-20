<%
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (userObj != null && role != null) {
        if ("1".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/user/index.jsp");
            return;
        }
    }
%> 