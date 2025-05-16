<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReelGood - Privacy Policy</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
  body, .page-wrapper {
    background: var(--background) !important;
    color: var(--foreground);
    min-height: 100vh;
  }
  .page-content {
    max-width: 700px;
    margin: 0 auto;
    padding: 2rem 1rem;
    flex: 1;
    width: 100%;
  }
  .privacy-header {
    text-align: center;
    margin-bottom: 2.5rem;
  }
  .privacy-header h1 {
    font-size: 2.2rem;
    margin-bottom: 0.5rem;
    color: var(--primary);
    font-weight: 700;
  }
  .privacy-tagline {
    color: var(--muted-foreground);
    font-size: 1.1rem;
  }
  .privacy-sections {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    margin-bottom: 2.5rem;
  }
  .privacy-section {
    background: #231818;
    color: #fff;
    padding: 1.5rem 1.5rem;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    max-width: 100%;
    margin: 0 auto;
  }
  .privacy-section h2 {
    font-size: 1.25rem;
    margin-bottom: 1rem;
    color: #ff4757;
    font-weight: 600;
  }
  .privacy-section p {
    color: #fff;
    line-height: 1.6;
    margin-bottom: 1rem;
  }
  .privacy-list {
    list-style-type: none;
    padding-left: 1.5rem;
    margin-bottom: 1rem;
  }
  .privacy-list li {
    position: relative;
    padding-left: 1rem;
    margin-bottom: 0.75rem;
    color: #e0e0e0;
    line-height: 1.5;
  }
  .privacy-list li::before {
    content: "•";
    position: absolute;
    left: -0.5rem;
    color: #ff4757;
  }
  .contact-email {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #ff4757;
    font-weight: 500;
  }
  .privacy-updated {
    text-align: center;
    color: #e0e0e0;
    font-size: 0.875rem;
    font-style: italic;
  }
  @media (max-width: 768px) {
    .privacy-header h1 { font-size: 1.5rem; }
    .privacy-section { padding: 1rem; }
    .privacy-section h2 { font-size: 1.1rem; }
    .page-content { max-width: 98vw; }
  }
  @media (max-width: 480px) {
    .privacy-header h1 { font-size: 1.2rem; }
    .privacy-tagline { font-size: 1rem; }
    .privacy-section { padding: 0.75rem; }
    .privacy-section h2 { font-size: 1rem; }
  }
  </style>
</head>
<body>
  <div class="page-wrapper">
    <jsp:include page="user-navbar.jsp" />
    <div class="page-content">
      <div class="privacy-header">
        <h1>Privacy and Policies</h1>
        <p class="privacy-tagline">What happens in ReelGood, stays in ReelGood.</p>
      </div>
      <div class="privacy-sections">
        <section class="privacy-section">
          <h2>1. Information We Collect</h2>
          <p>We may collect the following information:</p>
          <ul class="privacy-list">
            <li>Your name and email address (when booking or creating an account)</li>
            <li>Payment details (processed securely via third-party payment providers)</li>
            <li>Booking history and preferences</li>
            <li>Basic technical data (browser type, device, IP address)</li>
          </ul>
        </section>
        <section class="privacy-section">
          <h2>2. How We Use Your Information</h2>
          <p>We use your data to:</p>
          <ul class="privacy-list">
            <li>Process and confirm movie bookings</li>
            <li>Send booking confirmations or updates</li>
            <li>Improve our website and user experience</li>
            <li>Respond to customer service requests</li>
          </ul>
          <p>We do not sell or share your personal information with third parties for marketing purposes.</p>
        </section>
        <section class="privacy-section">
          <h2>3. Data Security</h2>
          <p>We take reasonable measures to protect your information using encryption, secure servers, and access controls. Payment information is handled by trusted payment gateways and is never stored on our servers.</p>
        </section>
        <section class="privacy-section">
          <h2>4. Cookies</h2>
          <p>ReelGood uses cookies to enhance site performance and improve user experience. You can control cookie settings in your browser.</p>
        </section>
        <section class="privacy-section">
          <h2>5. Your Choices</h2>
          <p>You can:</p>
          <ul class="privacy-list">
            <li>Access or update your personal information anytime</li>
            <li>Contact us to request data deletion</li>
            <li>Choose not to provide certain information, though it may limit your use of some features</li>
          </ul>
        </section>
        <section class="privacy-section">
          <h2>6. Contact Us</h2>
          <p>If you have any questions about this policy, please contact us at:</p>
          <p class="contact-email"><i class="fa-solid fa-envelope"></i> support@reelgood.com</p>
        </section>
      </div>
      <div class="privacy-updated">
        <p>Last updated: April 25, 2025</p>
      </div>
    </div>
    <jsp:include page="user-footer.jsp" />
  </div>
</body>
</html> 