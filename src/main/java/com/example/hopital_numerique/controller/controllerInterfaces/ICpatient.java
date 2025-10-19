package com.example.hopital_numerique.controller.controllerInterfaces;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface ICpatient {
    void showDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void showConsultations(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void showProfile(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void bookConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void cancelConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void updateProfile(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
