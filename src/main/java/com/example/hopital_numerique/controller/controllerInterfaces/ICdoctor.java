package com.example.hopital_numerique.controller.controllerInterfaces;

import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface ICdoctor {
    void showDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void showConsultations(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void showAppointments(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void showProfile(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void validateConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void refuseConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void addConsultationReport(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void updateConsultationReport(HttpServletRequest request, HttpServletResponse response) throws Exception;
    void updateConsultationStatus(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
