package com.reelgood.util;

import com.google.gson.Gson;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

public class JsonResponse {
    private static final Gson gson = new Gson();

    public static void sendSuccess(HttpServletResponse response, String message) throws IOException {
        sendSuccess(response, message, null);
    }

    public static void sendSuccess(HttpServletResponse response, String message, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);

        Map<String, Object> responseData = Map.of(
            "success", true,
            "message", message,
            "data", data != null ? data : Map.of()
        );

        response.getWriter().write(gson.toJson(responseData));
    }

    public static void sendError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(statusCode);

        Map<String, Object> responseData = Map.of(
            "success", false,
            "message", message
        );

        response.getWriter().write(gson.toJson(responseData));
    }
} 