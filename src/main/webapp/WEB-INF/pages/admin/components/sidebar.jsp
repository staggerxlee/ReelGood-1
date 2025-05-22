<link rel="stylesheet" href="${pageContext.request.contextPath}/css/newcss/admin-sidebar.css">
<div class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo"><a href="${pageContext.request.contextPath}/admin/dashboard" class="${pageContext.request.servletPath == '/admin/dashboard' ? 'active' : ''}"><img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="ReelGood Logo" style="width:200px;"></a></div>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="${pageContext.request.servletPath == '/admin/dashboard' ? 'active' : ''}"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/movies" class="${pageContext.request.servletPath == '/admin/movies' ? 'active' : ''}"><i class="fas fa-film"></i> Movies</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/bookings" class="${pageContext.request.servletPath == '/admin/bookings' ? 'active' : ''}"><i class="fas fa-ticket-alt"></i> Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users" class="${pageContext.request.servletPath == '/admin/users' ? 'active' : ''}"><i class="fas fa-users"></i> Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/schedules" class="${pageContext.request.servletPath == '/admin/schedules' ? 'active' : ''}"><i class="fas fa-calendar-alt"></i> Schedule Movie</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/support" class="${pageContext.request.servletPath == '/admin/support' ? 'active' : ''}"><i class="fas fa-headset"></i> Support</a></li>
        <li>
            <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:0;">
                <button type="submit" class="logout-btn" style="width:100%; font-weight:bold; text-align:left; font-size:16px;"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </form>
        </li>
    </ul>
</div> 