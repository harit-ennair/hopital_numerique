package com.example.hopital_numerique.controller;

import com.example.hopital_numerique.controller.controllerInterfaces.ICdoctor;
import com.example.hopital_numerique.dao.ConsulltationDao;
import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Person;
import com.example.hopital_numerique.model.Status;
import com.example.hopital_numerique.services.AdmenServ;
import com.example.hopital_numerique.services.DoctorServ;
import com.example.hopital_numerique.services.serviceIntefaces.ISdoctor;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor/*"})
public class DoctorCont extends HttpServlet implements ICdoctor {

    private final ISdoctor doctorService;

    public DoctorCont(ISdoctor doctorService) {
        this.doctorService = doctorService;
    }

    // Default constructor for servlet
    public DoctorCont() {
        this.doctorService = null; // Will be initialized in init()
    }

    private ISdoctor actualDoctorService;

    @Override
    public void init() throws ServletException {
        // Initialize the doctor service and controller
        try {
            ConsulltationDao consultationDao = new ConsulltationDao();
            AdmenServ adminServ = new AdmenServ(null, null, null, null, null); // You may need to adjust this
            this.actualDoctorService = new DoctorServ(consultationDao, adminServ);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize doctor service", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                pathInfo = "/dashboard";
            }

            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/consultations":
                    showConsultations(request, response);
                    break;
                case "/appointments":
                    showAppointments(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing doctor request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            switch (pathInfo) {
                case "/validate-consultation":
                    validateConsultation(request, response);
                    break;
                case "/refuse-consultation":
                    refuseConsultation(request, response);
                    break;
                case "/add-report":
                    addConsultationReport(request, response);
                    break;
                case "/update-report":
                    updateConsultationReport(request, response);
                    break;
                case "/update-status":
                    updateConsultationStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing doctor request", e);
        }
    }

    private ISdoctor getDoctorService() {
        ISdoctor service = actualDoctorService != null ? actualDoctorService : doctorService;
        if (service == null) {
            throw new IllegalStateException("Doctor service not initialized");
        }
        return service;
    }

    private Doctor getCurrentDoctor(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        Person user = (Person) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        return (Doctor) user;
    }

    @Override
    public void showDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        ISdoctor service = getDoctorService();
        // Get doctor's statistics for dashboard
        List<Consultation> allConsultations = service.getDoctorConsultations(doctor);
        List<Consultation> pendingAppointments = service.getPendingAppointments(doctor);

        long totalConsultations = allConsultations.size();
        long pendingCount = pendingAppointments.size();
        long completedCount = allConsultations.stream()
            .filter(c -> c.getStatus() == Status.COMPLETED)
            .count();
        long validatedCount = allConsultations.stream()
            .filter(c -> c.getStatus() == Status.VALIDATED)
            .count();

        request.setAttribute("doctor", doctor);
        request.setAttribute("totalConsultations", totalConsultations);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("validatedCount", validatedCount);
        request.setAttribute("recentConsultations", allConsultations.stream().limit(5).collect(Collectors.toList()));

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/doctor-dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void showConsultations(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        ISdoctor service = getDoctorService();
        String statusFilter = request.getParameter("status");
        List<Consultation> consultations;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            try {
                Status status = Status.valueOf(statusFilter.toUpperCase());
                consultations = service.getDoctorConsultations(doctor).stream()
                    .filter(c -> c.getStatus() == status)
                    .collect(Collectors.toList());
            } catch (IllegalArgumentException e) {
                consultations = service.getDoctorConsultations(doctor);
            }
        } else {
            consultations = service.getDoctorConsultations(doctor);
        }

        request.setAttribute("doctor", doctor);
        request.setAttribute("consultations", consultations);
        request.setAttribute("statusFilter", statusFilter);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/doctor-consultations.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void showAppointments(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        ISdoctor service = getDoctorService();
        List<Consultation> appointments = service.getPendingAppointments(doctor);

        request.setAttribute("doctor", doctor);
        request.setAttribute("appointments", appointments);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/doctor-appointments.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void showProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        request.setAttribute("doctor", doctor);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/doctor-profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void validateConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            ISdoctor service = getDoctorService();
            // You would need to add a method to get consultation by ID in your service
            // For now, we'll assume you have a way to get the consultation
            List<Consultation> consultations = service.getDoctorConsultations(doctor);
            Consultation consultation = consultations.stream()
                .filter(c -> c.getId() == consultationId)
                .findFirst()
                .orElse(null);

            if (consultation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found");
                return;
            }

            service.validateConsultation(consultation, doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=validated");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void refuseConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            ISdoctor service = getDoctorService();
            List<Consultation> consultations = service.getDoctorConsultations(doctor);
            Consultation consultation = consultations.stream()
                .filter(c -> c.getId() == consultationId)
                .findFirst()
                .orElse(null);

            if (consultation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found");
                return;
            }

            service.refuseConsultation(consultation, doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=refused");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void addConsultationReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        String report = request.getParameter("report");

        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            ISdoctor service = getDoctorService();
            List<Consultation> consultations = service.getDoctorConsultations(doctor);
            Consultation consultation = consultations.stream()
                .filter(c -> c.getId() == consultationId)
                .findFirst()
                .orElse(null);

            if (consultation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found");
                return;
            }

            // Set the report if provided
            if (report != null && !report.trim().isEmpty()) {
                consultation.setReport(report);
            }

            service.addConsultationReport(consultation, doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/consultations?success=report_added");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void updateConsultationReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        String report = request.getParameter("report");

        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            ISdoctor service = getDoctorService();
            List<Consultation> consultations = service.getDoctorConsultations(doctor);
            Consultation consultation = consultations.stream()
                .filter(c -> c.getId() == consultationId)
                .findFirst()
                .orElse(null);

            if (consultation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found");
                return;
            }

            // Update the report if provided
            if (report != null && !report.trim().isEmpty()) {
                consultation.setReport(report);
            }

            service.updateConsultationReport(consultation, doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/consultations?success=report_updated");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void updateConsultationStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Doctor doctor = getCurrentDoctor(request, response);
        if (doctor == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        String statusStr = request.getParameter("status");

        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            ISdoctor service = getDoctorService();
            List<Consultation> consultations = service.getDoctorConsultations(doctor);
            Consultation consultation = consultations.stream()
                .filter(c -> c.getId() == consultationId)
                .findFirst()
                .orElse(null);

            if (consultation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found");
                return;
            }

            // Update status if provided
            if (statusStr != null && !statusStr.isEmpty()) {
                Status status = Status.valueOf(statusStr.toUpperCase());
                consultation.setStatus(status);
            }

            service.updateConsultationStatus(consultation, doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/consultations?success=status_updated");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status value");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
