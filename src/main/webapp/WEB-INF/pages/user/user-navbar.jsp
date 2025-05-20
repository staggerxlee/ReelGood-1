<style>
  .user-navbar {
    background: #c00;
    color: #fff;
    width: 100%;
    padding: 0;
    margin: 0;
  }
  .navbar-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 32px;
    height: 100px;
  }
  .logo-container img {
    height: 80px;
    width: auto;
    object-fit: contain;
  }
  .main-navigation .nav-links {
    display: flex;
    gap: 32px;
    list-style: none;
    margin: 0;
    padding: 0;
  }
  .main-navigation .nav-link {
    color: #fff;
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    padding: 8px 16px;
    border-radius: 8px;
    transition: background 0.2s;
  }
  .main-navigation .nav-link:hover,
  .main-navigation .nav-link.active {
    background-color: #ff6b81;
    color: #fff;
  }
  .user-button .icon-user {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: none;
    background: #fff;
    color: #c00;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    text-decoration: none;
    transition: background 0.2s;
    padding: 0;
  }
  .user-button .icon-user:hover {
    background: #ffe9eb;
    color: #b71c1c;
  }
  .navbar-profile-photo-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 2px solid #fff;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
  }
  .navbar-profile-photo {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    display: block;
    position: absolute;
    left: 0;
    top: 0;
  }
  .navbar-profile-photo.default-avatar {
    color: #ff4757;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
  }
  @media (max-width: 900px) {
    .navbar-content {
      flex-direction: column;
      height: auto;
      padding: 16px;
      gap: 12px;
    }
    .main-navigation .nav-links {
      gap: 16px;
    }
  }
  </style>
  <div class="user-navbar">
    <div class="navbar-content">
      <div class="logo-container">
        <a href="<%= request.getContextPath() %>/user/index">
          <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="ReelGood Logo">
        </a>
      </div>
      <nav class="main-navigation">
        <ul class="nav-links">
          <li><a href="<%= request.getContextPath() %>/user/index" class="nav-link">Home</a></li>
          <li><a href="<%= request.getContextPath() %>/user/movies" class="nav-link">Movies</a></li>
          <li><a href="<%= request.getContextPath() %>/user/contact" class="nav-link">Help</a></li>
        </ul>
      </nav>
      <div class="user-button">
        <a href="<%= request.getContextPath() %>/user/profile" class="icon-user">
          <span class="navbar-profile-photo-circle">
            <img src="<%= request.getContextPath() %>/user-photo?id=${user.userID}" alt="Profile" class="navbar-profile-photo" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
            <span class="navbar-profile-photo default-avatar" style="display:none;"><i class="fa fa-user"></i></span>
          </span>
        </a>
      </div>
    </div>
  </div> 