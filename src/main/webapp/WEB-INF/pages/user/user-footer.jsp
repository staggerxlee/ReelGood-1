<style>
/* Footer Styles */
.site-footer {
  width: 100%;
  background-color: var(--footer);
  padding: 3rem 1rem;
  margin-top: 3rem;
  border-radius: 50px;
}
.footer-content {
  margin-bottom: 0;
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1.5rem;
}
.footer-logo img {
  display: block;
  height: auto;
  max-height: 60px;
  width: auto;
}
.social-links p {
  margin-bottom: 0.75rem;
  color: var(--muted-foreground);
  font-size: 0.875rem;
}
.social-icons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}
.social-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.1);
  color: var(--primary-foreground);
  transition: all 0.2s ease;
}
.social-icon:hover {
  background-color: var(--primary);
  transform: translateY(-2px);
}
.social-icon svg {
  width: 1.25rem;
  height: 1.25rem;
}
.footer-links {
  display: flex;
  gap: 2rem;
  margin: 0.5rem 0;
}
.footer-links a {
  color: var(--primary-foreground);
  font-size: 0.875rem;
  transition: color 0.2s ease;
}
.footer-links a:hover {
  color: var(--primary);
}
.contact-info {
  color: var(--muted-foreground);
  font-size: 0.875rem;
}
.copyright {
  color: var(--muted-foreground);
  font-size: 0.75rem;
  margin-top: 0.5rem;
}
</style>
<footer class="site-footer">
  <div class="footer-content">
    <div class="footer-logo">
      <img src="<%= request.getContextPath() %>/images/ReelGood.jpg" alt="ReelGood Logo">
    </div>
    <div class="social-links">
      <p>Follow Us:</p>
      <div class="social-icons">
        <a href="https://www.facebook.com/" class="social-icon" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
        <a href="https://www.instagram.com/" class="social-icon" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
        <a href="https://www.x.com/" class="social-icon" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
      </div>
    </div>
    <div class="footer-links">
      <a href="<%= request.getContextPath() %>/user/privacy">Privacy Policy</a>
      <a href="<%= request.getContextPath() %>/user/contact">FAQs</a>
      <a href="<%= request.getContextPath() %>/user/aboutus">About Us</a>
    </div>
    <div class="contact-info">
      Contact: 9800000000 | reelgood.contact@gmail.com
    </div>
    <div class="copyright">
      ©ReelGood 2025. All Rights Reserved.
    </div>
  </div>
</footer> 