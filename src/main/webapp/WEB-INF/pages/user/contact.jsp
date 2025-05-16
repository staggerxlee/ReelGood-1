<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReelGood - Contact Us</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/newcss/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <style>
    .page-wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
      }
      .page-content {
        max-width: 900px;
        margin: 0 auto;
        padding: 2rem 1rem;
        flex: 1;
      }
      /* Contact Page Styles */
      .page-content {
        max-width: 900px;
        margin: 0 auto;
        padding: 2rem 1rem;
      }
      /* Contact Section */
      .contact-section {
        margin-bottom: 3rem;
        background-color: var(--muted);
        padding: 2rem;
        border-radius: var(--radius);
        box-shadow: var(--shadow);
      }
      .contact-section h1 {
        font-size: 2rem;
        margin-bottom: 0.5rem;
        color: var(--foreground);
      }
      .contact-tagline {
        color: var(--muted-foreground);
        margin-bottom: 2rem;
        font-size: 1rem;
      }
      .contact-form {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
      }
      .form-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
      }
      .form-group label {
        font-weight: 500;
        color: var(--foreground);
      }
      .input-group {
        position: relative;
      }
      .input-group input,
      .input-group textarea {
        width: 100%;
        padding: 0.75rem 1rem;
        background-color: rgba(0, 0, 0, 0.2);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        color: var(--foreground);
        font-family: inherit;
        font-size: 1rem;
        transition: border-color 0.3s;
      }
      .input-group textarea {
        min-height: 150px;
        resize: vertical;
      }
      .input-group input:focus,
      .input-group textarea:focus {
        outline: none;
        border-color: var(--primary);
      }
      .error-message {
        color: var(--primary);
        font-size: 0.875rem;
        margin-top: 0.25rem;
        display: block;
        min-height: 1.25rem;
      }
      .submit-btn {
        align-self: flex-end;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        background-color: var(--primary);
        color: var(--primary-foreground);
        border: none;
        border-radius: var(--radius);
        padding: 0.75rem 1.5rem;
        font-weight: 500;
        cursor: pointer;
        transition: background-color 0.3s;
      }
      .submit-btn:hover {
        background-color: var(--primary-hover);
      }
      .submit-btn i {
        font-size: 0.875rem;
      }
      /* FAQ Section */
      .faq-section {
        margin-bottom: 3rem;
      }
      .faq-section h2 {
        font-size: 2rem;
        margin-bottom: 0.5rem;
        color: var(--foreground);
        text-align: center;
      }
      .faq-tagline {
        color: var(--muted-foreground);
        margin-bottom: 2rem;
        font-size: 1rem;
        text-align: center;
      }
      .faq-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
      }
      .faq-item {
        background-color: var(--muted);
        padding: 1.5rem;
        border-radius: var(--radius);
        box-shadow: var(--shadow);
      }
      .faq-item h3 {
        font-size: 1.125rem;
        margin-bottom: 0.75rem;
        color: var(--foreground);
      }
      .faq-item p {
        color: var(--muted-foreground);
        line-height: 1.6;
      }
      @media (max-width: 768px) {
        .contact-section,
        .faq-item {
          padding: 1.5rem;
        }
        .submit-btn {
          align-self: stretch;
          justify-content: center;
        }
      }
      @media (max-width: 480px) {
        .contact-section h1,
        .faq-section h2 {
          font-size: 1.5rem;
        }
        .faq-item h3 {
          font-size: 1rem;
        }
      }
      .site-footer {
        width: 100%;
        margin-top: auto;
      }
      .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 3rem 1rem;
      }
  </style>
</head>
<body>
  <jsp:include page="user-navbar.jsp" />
  <div class="page-wrapper">
    <div class="page-content">
      <div class="contact-section">
        <h1>Contact Us</h1>
        <p class="contact-tagline">Mission Possible. Tom Cruise will be at your service soon.</p>
        <form id="contact-form" class="contact-form" method="post" action="<%= request.getContextPath() %>/user/contact">
          <div class="form-group">
            <label for="contact-email">Email:</label>
            <div class="input-group">
              <input type="email" id="contact-email" name="email" placeholder="Enter your email">
              <span class="error-message"></span>
            </div>
          </div>
          <div class="form-group">
            <label for="contact-message">Problem Faced:</label>
            <div class="input-group">
              <textarea id="contact-message" name="message" placeholder="Describe your issue in detail"></textarea>
              <span class="error-message"></span>
            </div>
          </div>
          <button type="submit" class="submit-btn">
            <span>Submit</span>
            <i class="fa-solid fa-check"></i>
          </button>
        </form>
        <c:if test="${not empty success}">
          <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
          <div class="alert alert-error">${error}</div>
        </c:if>
      </div>
      <div class="faq-section">
        <h2>FAQs</h2>
        <p class="faq-tagline">"Lights, Camera... Clarification!"</p>
        <div class="faq-list">
          <div class="faq-item">
            <h3>1. How do I book a movie ticket on ReelGood?</h3>
            <p>Browse movies, choose the preferred showtime and seats, and click "Book Now". You'll get a confirmation on-screen and via email—no paperwork!</p>
          </div>
          <div class="faq-item">
            <h3>2. Do I need to create an account to book tickets?</h3>
            <p>Nope! Booking as a guest is available for convenience. However, signing up lets you track bookings, get reminders, and earn real-good perks in the future.</p>
          </div>
          <div class="faq-item">
            <h3>3. Can I cancel/modify my booking after payment?</h3>
            <p>Yes, you can cancel your bookings after payment. Although, please double-check your selection before booking!</p>
          </div>
          <div class="faq-item">
            <h3>4. What payment methods does ReelGood accept?</h3>
            <p>We accept major credit/debit cards and secure digital wallets. All transactions are encrypted for your safety—pay with peace of mind.</p>
          </div>
          <div class="faq-item">
            <h3>5. The movie I want isn't listed. What should I do?</h3>
            <p>We're constantly updating our selection. If something's missing, check back soon or reach us through the Contact Us page—we're always listening behind the scenes!</p>
          </div>
        </div>
      </div>
    </div>
    <jsp:include page="user-footer.jsp" />
  </div>
  <script src="<%= request.getContextPath() %>/js/contact.js"></script>
</body>
</html> 