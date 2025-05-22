<style>
  body {
    background: #101c1c;
  }
  .user-navbar {
    background: transparent;
    width: 100%;
    padding: 0;
    margin: 0;
    box-shadow: none;
  }
  .navbar-content {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    width: 100%;
    margin: 32px 0 0 0;
    padding: 0;
  }
  .navbar-group {
    display: flex;
    align-items: center;
    gap: 16px;
    width: 100%;
    max-width: 1100px;
    margin: 0 auto;
  }
  .navbar-bar {
    background: #c00;
    border-radius: 28px;
    display: flex;
    align-items: center;
    padding: 0 32px;
    height: 72px;
    min-width: 0;
    flex: 1 1 auto;
    gap: 12px;
    margin: 0;
    box-shadow: none;
    width: 100%;
  }
  .logo-container {
    display: flex;
    align-items: center;
    margin-right: 160px;
  }
  .logo-container img {
    height: 64px;
    width: auto;
    object-fit: contain;
  }
  .nav-links {
    display: flex;
    gap: 32px;
    list-style: none;
    margin: 0;
    padding: 0;
  }
  .nav-link {
    color: #fff;
    text-decoration: none;
    font-weight: 600;
    font-size: 19px;
    padding: 8px 0;
    border-radius: 8px;
    letter-spacing: 0.01em;
  }
  
  
  .navbar-search {
    display: flex;
    align-items: center;
    background: #101c1c;
    border-radius: 24px;
    padding: 0 20px;
    margin-left: auto;
    margin-right: 0;
    min-width: 120px;
    height: 48px;
    box-shadow: none;
    width: 180px;
  }
  .navbar-search .search-input {
    border: none;
    outline: none;
    background: transparent;
    color: #fff;
    font-size: 16px;
    padding: 6px 0;
    width: 100%;
  }
  .navbar-search .search-input::placeholder {
    color: #fff;
    opacity: 0.7;
    font-size: 22px;
  }
  .navbar-search .search-btn {
    background: none;
    border: none;
    border-radius: 50%;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 28px;
    margin-left: 4px;
    cursor: pointer;
    box-shadow: none;
  }
  .user-button {
    margin-left: 0;
    display: flex;
    align-items: center;
    background: #181f1f;
    border-radius: 16px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.18);
    width: 48px;
    height: 48px;
  }
  .icon-user {
    width: 48px;
    height: 48px;
    border-radius: 16px;
    border: none;
    background: transparent;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    text-decoration: none;
  }
  .navbar-profile-photo-circle {
    width: 48px;
    height: 48px;
    border-radius: 16px;
    border: none;
    background: transparent;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
  }
  .navbar-profile-photo {
    width: 100%;
    height: 100%;
    border-radius: 16px;
    object-fit: cover;
    display: block;
    position: absolute;
    left: 0;
    top: 0;
  }
  .navbar-profile-photo.default-avatar {
    color: #fff;
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
    .navbar-bar {
      flex-direction: column;
      gap: 16px;
      padding: 12px;
      height: auto;
    }
    .navbar-search {
      margin: 16px 0;
      width: 100%;
    }
  }
</style>
<div class="user-navbar">
  <div class="navbar-content">
    <div class="navbar-group">
      <div class="navbar-bar">
        <div class="logo-container">
          <a href="<%= request.getContextPath() %>/user/index">
            <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="ReelGood Logo">
          </a>
        </div>
        <ul class="nav-links">
          <li><a href="<%= request.getContextPath() %>/user/index" class="nav-link">Home</a></li>
          <li><a href="<%= request.getContextPath() %>/user/movies" class="nav-link">Movies</a></li>
          <li><a href="<%= request.getContextPath() %>/user/contact" class="nav-link">Help</a></li>
        </ul>
        <form class="navbar-search" action="<%= request.getContextPath() %>/user/search" method="get">
          <input type="text" name="q" class="search-input">
          <button type="submit" class="search-btn"><i class="fa fa-search"></i></button>
        </form>
      </div>
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
</div> 