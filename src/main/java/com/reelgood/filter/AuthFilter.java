package com.reelgood.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;

@WebFilter(urlPatterns = {"/user/*", "/user", "/admin/*", "/admin"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String requestPath = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isAdminURL = requestPath.startsWith(contextPath + "/admin") && !requestPath.equals(contextPath + "/admin/login");
        boolean isUserURL = requestPath.startsWith(contextPath + "/user") && !requestPath.equals(contextPath + "/user/login");
        boolean isAdmin = isLoggedIn && "2".equals(session.getAttribute("role"));

        // Debug logging
        System.out.println("[AuthFilter] RequestPath: " + requestPath);
        System.out.println("[AuthFilter] Session ID: " + (session != null ? session.getId() : "null"));
        System.out.println("[AuthFilter] User: " + (session != null ? session.getAttribute("user") : "null"));
        System.out.println("[AuthFilter] Role: " + (session != null ? session.getAttribute("role") : "null"));
        System.out.println("[AuthFilter] IsLoggedIn: " + isLoggedIn);
        System.out.println("[AuthFilter] IsAdminURL: " + isAdminURL);
        System.out.println("[AuthFilter] IsUserURL: " + isUserURL);
        System.out.println("[AuthFilter] IsAdmin: " + isAdmin);
        // Log the value of reelgood_session for coursework demonstration
        String customSessionId = null;
        Cookie[] cookies = httpRequest.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("reelgood_session".equals(cookie.getName())) {
                    customSessionId = cookie.getValue();
                    break;
                }
            }
        }
        System.out.println("[AuthFilter] reelgood_session cookie: " + customSessionId);
        
        // Debug logging
        System.out.println("[DEBUG] AuthFilter: All cookies: " + Arrays.toString(httpRequest.getCookies()));
        System.out.println("[DEBUG] AuthFilter: Session: " + session);
        System.out.println("[DEBUG] AuthFilter: Session ID: " + (session != null ? session.getId() : "null"));
        System.out.println("[DEBUG] AuthFilter: User: " + (session != null ? session.getAttribute("user") : "null"));
        System.out.println("[DEBUG] AuthFilter: Role: " + (session != null ? session.getAttribute("role") : "null"));
        System.out.println("[DEBUG] AuthFilter: RequestPath: " + requestPath);
        
        if (isLoggedIn) {
            // User is logged in
            if (isAdminURL && !isAdmin) {
                // Non-admin trying to access admin area
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/dashboard");
            } else {
                // Allow logged-in user to continue
                chain.doFilter(request, response);
            }
        } else {
            // User is not logged in
            if (isUserURL || isAdminURL) {
                // Redirect to login page
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            } else {
                // Allow public resources to be accessed
                chain.doFilter(request, response);
            }
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}