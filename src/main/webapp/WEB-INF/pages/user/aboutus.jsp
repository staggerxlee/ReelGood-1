<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Who We Are - ReelGood</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
    /* Base Styles */
    :root {
      --primary: #f62428;
      --primary-hover: #d91f23;
      --primary-foreground: #ffffff;
      --background: #0a1419;
      --foreground: #ffffff;
      --muted: #2a2a2a;
      --muted-foreground: #b0a8a8;
      --border: #333333;
      --header: #bd0202;
      --footer: #1a0505;
      --card-bg: #2a2a2a;
      --radius: 0.5rem;
      --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.3), 0 1px 2px 0 rgba(0, 0, 0, 0.2);
      --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.3), 0 4px 6px -2px rgba(0, 0, 0, 0.2);
    }
    
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    
    body {
      font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans",
        "Helvetica Neue", sans-serif;
      color: var(--foreground);
      background-color: var(--background);
      line-height: 1.5;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0;
      width: 100%;
    }
    
    h1, h2, h3, h4, h5, h6 {
      font-weight: 700;
      line-height: 1.2;
      margin-bottom: 1rem;
    }
    
    a {
      color: var(--primary);
      text-decoration: none;
      transition: color 0.2s ease;
    }
    
    a:hover {
      color: var(--primary-hover);
    }
    
    /* Header Placeholder */
    .header-placeholder {
      height: 80px;
      background-color: var(--header);
      margin-bottom: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
    }
    
    /* Hero Section */
    .hero-section {
      position: relative;
      height: 840px;
      width:auto;
      background-image: url('${pageContext.request.contextPath}/images/background-aboutus.png');
      background-position: center;
      display: flex;
      align-items: center;
      padding: 0 2rem;
    }
    
    .hero-overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.7);
      z-index: 1;
    }
    
    .hero-content {
      margin-top:300px;
      position: relative;
      z-index: 2;
      display: flex;
      width: 100%;
    }
    
    .hero-title {
      flex: 1;
      font-size: 7rem;
      font-weight: 800;
      text-transform: uppercase;
      line-height: 1;
      color: white;
    }
    
    .hero-description {
      flex: 2;
      background-color: rgba(42, 42, 42, 0.8);
      padding: 2rem;
      border-radius: var(--radius);
      font-size: 1rem;
      line-height: 1.6;
    }
    
    .hero-logo {
      display: block;
      width: 300px;
      margin: 0 auto 2rem;
    }
    
    .mission-tagline {
      text-align: center;
      font-style: italic;
      margin-top: 7rem;
      font-size: 1.2rem;
      color: var(--primary);
    }
    
    .location-link {
      text-align: left;
      font-style: italic;
      font-size: 1rem;
      color: var(--primary);
    }
    
    /* Locations Section */
    .locations-section {
      padding: 4rem 2rem;
    }
    
    .locations-title {
      font-size: 4rem;
      text-align: right;
      margin-bottom: 2rem;
      display: flex;
      align-items: center;
      justify-content: flex-end;
    }
    
    .locations-title i {
      color: var(--primary);
      font-size: 4rem;
      margin-left: 1rem;
    }
    
    .locations-subtitle {
      text-align: right;
      font-size: 1rem;
      color: var(--muted-foreground);
      margin-bottom: 3rem;
    }
    
    
    
    
        .credits-container {
      max-height: 800px;
      max-width: 400px;
      overflow-y: auto;
      padding-right: 1rem;
      /* Scrollbar styling */
      scrollbar-width: thin;
      scrollbar-color: var(--primary) var(--muted);
      border-radius:50px;
    }

    .location-card {
      display: flex;
      margin-bottom: 3rem;
      background-color: var(--card-bg);
      border-radius: var(--radius);
      overflow: hidden;
    }
    
    .location-card:nth-child(even) {
      flex-direction: row-reverse;
    }
    
    .location-image {
      flex: 1;
      min-width: 300px;
      max-width: 400px;
      height: 300px;
      object-fit: cover;
    }
    
    .location-info {
      flex: 1;
      padding: 2rem;
    }
    
    .location-name {
      font-size: 1.8rem;
      margin-bottom: 1rem;
    }
    
    .location-description {
      font-size: 1rem;
      line-height: 1.6;
    }
    
    /* Credits Section */
    .credits-section {
      padding: 4rem 2rem;
      background-color: #000000;
      color: white;
    }
    
    .credits-title {
      font-size: 3rem;
      text-align: center;
      margin-bottom: 1.5rem;
      position: relative;
      color: white;
    }
    
    .credits-title:after {
      content: '';
      display: block;
      width: 100%;
      height: 1px;
      background-color: #333;
      margin: 1rem auto;
    }
    
    .credits-container {
      max-width: 600px;
      margin: 0 auto;
      text-align: center;
    }
    
    .credits-container::-webkit-scrollbar {
      width: 8px;
    }
    
    .credits-container::-webkit-scrollbar-track {
      background: var(--muted);
      border-radius: 10px;
    }
    
    .credits-container::-webkit-scrollbar-thumb {
      background-color: var(--primary);
      border-radius: 10px;
    }

    .credit-item {
      margin-bottom: 2rem;
      padding-bottom: 2rem;
      border-bottom: 1px solid #333;
    }
    
    .credit-item:last-child {
      border-bottom: none;
    }
    
    .credit-row {
      display: flex;
      margin-bottom: 0.5rem;
      justify-content: center;
      align-items: flex-start;
    }
    
    .credit-label {
      flex: 0 0 150px;
      font-weight: 600;
      text-align: right;
      padding-right: 20px;
    }
    
    .credit-content {
      flex: 0 0 250px;
      text-align: left;
    }
    
    .credit-person {
      font-size: 1.2rem;
      font-weight: 700;
      text-transform: uppercase;
    }
    
    .credit-subtitle {
      font-size: 0.9rem;
      color: #999;
      font-style: italic;
      margin-bottom: 0.5rem;
    }
    
    .credit-contribution-item {
      margin-bottom: 0.25rem;
    }
    
    .developers-title {
      font-size: 2rem;
      text-align: center;
      margin: 3rem 0 1rem;
    }
    
    .developers-subtitle {
      font-size: 1rem;
      text-align: center;
      color: #999;
      font-style: italic;
      margin-bottom: 2rem;
    }
    
    .footer-placeholder {
      height: 200px;
      background-color: var(--footer);
      margin-top: auto;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
    }
    
   
    
    /* Responsive */
    @media (max-width: 992px) {
      .hero-content {
        flex-direction: column;
      }
      
      .hero-title {
        margin-bottom: 2rem;
        font-size: 4rem;
      }
      
      .location-card, .location-card:nth-child(even) {
        flex-direction: column;
      }
      
      .location-image {
        max-width: 100%;
        width: 100%;
      }
      
    }
    
    @media (max-width: 768px) {
      .hero-title {
        font-size: 3rem;
      }
      
      .locations-title {
        font-size: 3rem;
      }
      
      .locations-title i {
        font-size: 3rem;
      }
      
      .credit-row {
        flex-direction: column;
        align-items: center;
      }
      
      .credit-label {
        text-align: center;
        padding-right: 0;
        margin-bottom: 0.5rem;
      }
      
      .credit-content {
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="user-navbar.jsp"/>

  <!-- Hero Section -->
  <section class="hero-section">
    <div class="hero-content">
     
      <div class="hero-title">
     
        WHO<br>WE<br>ARE
      </div>
      <div class="hero-description">
        
        <p>At ReelGood, we believe that the magic of cinema should begin long before the opening credits roll. Our mission is simple: to make your movie-going experience faster, easier, and more enjoyable.</p>
        <br>
        <p>Founded with a passion for both technology and entertainment, ReelGood is an online platform designed to streamline the way you discover and book movie tickets. Whether you're planning a night out with friends or a spontaneous solo trip to the cinema, we're here to make sure you never miss a show. We're more than just a booking system – we're movie lovers just like you. That's why we built a platform that not only handles the logistics but also enhances the anticipation. With a sleek interface, smart filters, and intuitive features, ReelGood is built to help you find the right movie, at the right time, at the right place.</p>
        <br>
        <p>We aim to become the go-to destination for moviegoers everywhere – a one-stop hub where the love of film meets the ease of technology. Whether it's a premiere night, a matinee, or a midnight screening, ReelGood is here to get you there. Thank you for choosing ReelGood. Let's make every movie night unforgettable.</p>
      </div>
    </div>
  </section>
  
  <div class="mission-tagline">~ We are Mission: Bookable ~</div>

  <!-- Locations Section -->
  <section class="locations-section">
    <div class="container">
      <h2 class="locations-title">
        OUR LOCATIONS <i class="fas fa-map-marker-alt"></i>
      </h2>
      <p class="locations-subtitle">Your Indiana Jones Treasure Found.</p>
      
 
        <!-- Location Template - Can be repeated for more locations -->
        <div class="location-card">
          <img src="${pageContext.request.contextPath}/images/theater1.jpg" alt="ReelGood New Baneshwor" class="location-image">
          <div class="location-info">
            <h3 class="location-name">ReelGood New Baneshwor</h3>
            <p class="location-description">
              Located in the bustling heart of Baneshwor, this hall offers a spacious and well-equipped venue suitable for conferences, meetings, seminars, and social events. It features modern audio-visual equipment, comfortable seating arrangements, and easy accessibility with ample parking nearby. Ideal for both corporate and community gatherings.
            </p>
            <div class="location-link">
            <i class="fas fa-map-marker-alt"></i>
            <a href="https://maps.app.goo.gl/uRGKDYCp4yRjugJDA">View Location</a>
            </div>
          </div>
        </div>
        
        <div class="location-card">
          <img src="${pageContext.request.contextPath}/images/theater2.jpg" alt="ReelGood Putalisadak" class="location-image">
          <div class="location-info">
            <h3 class="location-name">ReelGood Putalisadak</h3>
            <p class="location-description">
              Situated in the vibrant commercial area of Putalisadak, this hall is perfect for workshops, training sessions, and medium-sized events. It boasts a professional ambiance with excellent lighting and sound systems, making it an excellent choice for business meetings and cultural programs. Conveniently located with good public transport links.
            </p>
             <div class="location-link">
            <i class="fas fa-map-marker-alt"></i>
            <a href="https://maps.app.goo.gl/UqNTAEGN5Nzi4mJx7">View Location</a>
            </div>
          </div>
        </div>
        
        <div class="location-card">
          <img src="${pageContext.request.contextPath}/images/theater3.jpg" alt="ReelGood Bagbazar" class="location-image">
          <div class="location-info">
            <h3 class="location-name">ReelGood Bagbazar</h3>
            <p class="location-description">
              Nestled in the historic and culturally rich area of Bagbazar, this hall provides a charming and versatile space for various events including cultural shows, private functions, and small conferences. It features traditional decor blended with modern amenities to offer a unique atmosphere. Easily accessible and close to major landmarks.
            </p>
            <div class="location-link">
            <i class="fas fa-map-marker-alt"></i>
            <a href="https://maps.app.goo.gl/g1s6mU6pMHWMPVvd7">View Location</a>
            </div>
          </div>
        </div>
        
      
    </div>
  </section>

  <!-- Credits Section -->
  
  <section class="credits-section">
    <div class="container">
      <h2 class="credits-title">Credits</h2>
      
      <div class="credits-container">
        <div class="credit-item">
          <div class="credit-row">
            <div class="credit-label">Team Leader:</div>
            <div class="credit-content">
              <div class="credit-person">SARTHAK BANIYA</div>
              <div class="credit-subtitle">The Chosen One</div>
            </div>
          </div>
          <div class="credit-row">
            <div class="credit-label">Contribution:</div>
            <div class="credit-content">
              <div class="credit-contribution-item">Frontend Design</div>
              <div class="credit-contribution-item">Wireframes</div>
              <div class="credit-contribution-item">Report Formatting</div>
              <div class="credit-contribution-item">Report Writing</div>
            </div>
          </div>
        </div>
        
        <h3 class="developers-title">Meet the Developers</h3>
        <p class="developers-subtitle">AKA: The CodeFathers</p>
        
        <div class="credit-item">
          <div class="credit-row">
            <div class="credit-label">FrontEnd:</div>
            <div class="credit-content">
              <div class="credit-person">DISHANT PANJIYAR</div>
              <div class="credit-subtitle">500 Days of FlexBox</div>
            </div>
          </div>
          <div class="credit-row">
            <div class="credit-label">Contribution:</div>
            <div class="credit-content">
              <div class="credit-contribution-item">Frontend Design</div>
              <div class="credit-contribution-item">Wireframes</div>
              <div class="credit-contribution-item">Report Formatting</div>
              <div class="credit-contribution-item">Report Writing</div>
            </div>
          </div>
        </div>
        
        <div class="credit-item">
          <div class="credit-row">
            <div class="credit-label">Full-Stack:</div>
            <div class="credit-content">
              <div class="credit-person">SASWAT KHATRY</div>
              <div class="credit-subtitle">The Iron Stack</div>
            </div>
          </div>
          <div class="credit-row">
            <div class="credit-label">Contribution:</div>
            <div class="credit-content">
              <div class="credit-contribution-item">Frontend Design</div>
              <div class="credit-contribution-item">Wireframes</div>
              <div class="credit-contribution-item">Report Formatting</div>
              <div class="credit-contribution-item">Report Writing</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  

  <jsp:include page="user-footer.jsp"/>
  </div>
</body>
</html>
