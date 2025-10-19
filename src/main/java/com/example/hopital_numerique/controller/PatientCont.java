package com.example.hopital_numerique.controller;

import com.example.hopital_numerique.controller.controllerInterfaces.ICpatient;
import com.example.hopital_numerique.dao.ConsulltationDao;
import com.example.hopital_numerique.dao.DoctorDao;
import com.example.hopital_numerique.dao.PatientDao;
import com.example.hopital_numerique.dao.RoomDao;
import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Person;
import com.example.hopital_numerique.model.Status;
import com.example.hopital_numerique.services.PatientServ;
import com.example.hopital_numerique.services.serviceIntefaces.ISpatien;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "PatientServlet", urlPatterns = {"/patient"})
public class PatientCont extends HttpServlet implements ICpatient {

    private final ISpatien patientService;

    public PatientCont(ISpatien patientService) {
        this.patientService = patientService;
    }

    // Default constructor for servlet
    public PatientCont() {
        this.patientService = null; // Will be initialized in init()
    }

    private ISpatien actualPatientService;

    @Override
    public void init() throws ServletException {
        // Initialize the patient service
        try {
            ConsulltationDao consultationDao = new ConsulltationDao();
            DoctorDao doctorDao = new DoctorDao();
            RoomDao roomDao = new RoomDao();
            PatientDao patientDao = new PatientDao();
            this.actualPatientService = new PatientServ(consultationDao, doctorDao, roomDao, patientDao);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize patient service", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null || action.isEmpty()) {
                action = "dashboard";
            }

            switch (action) {
                case "dashboard":
                    showDashboard(request, response);
                    break;
                case "consultations":
                    showConsultations(request, response);
                    break;
                case "profile":
                    showProfile(request, response);
                    break;
                case "book-consultation":
                    showBookConsultationForm(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing patient request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "book-consultation":
                    bookConsultation(request, response);
                    break;
                case "cancel-consultation":
                    cancelConsultation(request, response);
                    break;
                case "update-profile":
                    updateProfile(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing patient request", e);
        }
    }

    private ISpatien getPatientService() {
        ISpatien service = actualPatientService != null ? actualPatientService : patientService;
        if (service == null) {
            throw new IllegalStateException("Patient service not initialized");
        }
        return service;
    }

    private Patient getCurrentPatient(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        Person user = (Person) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        return (Patient) user;
    }

    @Override
    public void showDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        // Get patient's consultations for dashboard
        List<Consultation> allConsultations = patient.getConsultations();

        if (allConsultations == null || allConsultations.isEmpty()) {
            allConsultations = List.of(); // Empty list
        }

        long totalConsultations = allConsultations.size();
        long pendingCount = allConsultations.stream()
            .filter(c -> c.getStatus() == Status.PENDING)
            .count();
        long completedCount = allConsultations.stream()
            .filter(c -> c.getStatus() == Status.COMPLETED)
            .count();
        long validatedCount = allConsultations.stream()
            .filter(c -> c.getStatus() == Status.VALIDATED)
            .count();

        request.setAttribute("patient", patient);
        request.setAttribute("totalConsultations", totalConsultations);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("validatedCount", validatedCount);
        request.setAttribute("recentConsultations", allConsultations.stream().limit(5).collect(Collectors.toList()));

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/patient-dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void showConsultations(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        String statusFilter = request.getParameter("status");
        List<Consultation> consultations = patient.getConsultations();

        if (consultations == null) {
            consultations = List.of(); // Empty list
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            try {
                Status status = Status.valueOf(statusFilter.toUpperCase());
                consultations = consultations.stream()
                    .filter(c -> c.getStatus() == status)
                    .collect(Collectors.toList());
            } catch (IllegalArgumentException e) {
                // If invalid status, show all consultations
            }
        }

        request.setAttribute("patient", patient);
        request.setAttribute("consultations", consultations);
        request.setAttribute("statusFilter", statusFilter);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/patient-consultations.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void showProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        request.setAttribute("patient", patient);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/patient-profile.jsp");
        dispatcher.forward(request, response);
    }

    private void showBookConsultationForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        // Get available doctors and rooms for booking
        request.setAttribute("patient", patient);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/Views/patient-book-consultation.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public void bookConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        String doctorIdStr = request.getParameter("doctorId");
        String roomIdStr = request.getParameter("roomId");
        String dateStr = request.getParameter("consultationDate");
        String timeStr = request.getParameter("consultationTime");

        if (doctorIdStr == null || roomIdStr == null || dateStr == null || timeStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required");
            return;
        }

        try {
            LocalDate consultationDate = LocalDate.parse(dateStr);
            LocalTime consultationTime = LocalTime.parse(timeStr);

            // Create new consultation
            Consultation consultation = new Consultation();
            consultation.setPatient(patient);
            consultation.setDate(consultationDate);
            consultation.setHour(consultationTime);
            consultation.setStatus(Status.PENDING);

            // You would need to get doctor and room objects and set them
            // For now, this is a placeholder implementation

            response.sendRedirect(request.getContextPath() + "/patient?action=consultations&success=booked");

        } catch (java.time.format.DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date or time format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void cancelConsultation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        String consultationIdStr = request.getParameter("consultationId");
        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Consultation ID is required");
            return;
        }

        try {
            long consultationId = Long.parseLong(consultationIdStr);
            List<Consultation> consultations = patient.getConsultations();

            if (consultations != null) {
                Consultation consultation = consultations.stream()
                    .filter(c -> c.getId() == consultationId && c.getStatus() == Status.PENDING)
                    .findFirst()
                    .orElse(null);

                if (consultation == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation not found or cannot be cancelled");
                    return;
                }

                // Update consultation status to cancelled
                consultation.setStatus(Status.REFUSED);

                response.sendRedirect(request.getContextPath() + "/patient?action=consultations&success=cancelled");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No consultations found");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid consultation ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    public void updateProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Patient patient = getCurrentPatient(request, response);
        if (patient == null) return;

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");

        try {
            if (firstName != null && !firstName.trim().isEmpty()) {
                patient.setFirstName(firstName.trim());
            }
            if (lastName != null && !lastName.trim().isEmpty()) {
                patient.setLastName(lastName.trim());
            }
            if (email != null && !email.trim().isEmpty()) {
                patient.setEmail(email.trim());
            }
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                float weight = Float.parseFloat(weightStr);
                patient.setWeight(weight);
            }
            if (heightStr != null && !heightStr.trim().isEmpty()) {
                float height = Float.parseFloat(heightStr);
                patient.setHeight(height);
            }

            // Update patient in database (you'll need to implement this in the service)
            // getPatientService().updatePatient(patient);

            response.sendRedirect(request.getContextPath() + "/patient?action=profile&success=updated");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid weight or height format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
