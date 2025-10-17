package com.example.hopital_numerique.controller;

import com.example.hopital_numerique.controller.controllerInterfaces.ICadmen;
import com.example.hopital_numerique.dao.*;
import com.example.hopital_numerique.model.*;
import com.example.hopital_numerique.services.AdmenServ;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdmenCont extends HttpServlet implements ICadmen {

    private AdmenServ adminService;

    @Override
    public void init() throws ServletException {
        // Initialize DAOs and service
        DepartmentDao departmentDao = new DepartmentDao();
        DoctorDao doctorDao = new DoctorDao();
        RoomDao roomDao = new RoomDao();
        ConsulltationDao consultationDao = new ConsulltationDao();
        PatientDao patientDao = new PatientDao();

        this.adminService = new AdmenServ(departmentDao, doctorDao, roomDao, consultationDao , patientDao);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is admin
        if (!isAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showDashboard(request, response);
        } else {
            switch (pathInfo) {
                case "/patients":
                    showPatients(request, response);
                    break;
                case "/doctors":
                    showDoctors(request, response);
                    break;
                case "/departments":
                    showDepartments(request, response);
                    break;
                case "/rooms":
                    showRooms(request, response);
                    break;
                case "/consultations":
                    showConsultations(request, response);
                    break;
                case "/reports":
                    showReports(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is admin
        if (!isAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        try {
            if (pathInfo != null && action != null) {
                switch (pathInfo) {
                    case "/departments":
                        handleDepartmentAction(request, response, action);
                        break;
                    case "/doctors":
                        handleDoctorAction(request, response, action);
                        break;
                    case "/rooms":
                        handleRoomAction(request, response, action);
                        break;
                    case "/patients":
                        handlePatientAction(request, response, action);
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Person user = (Person) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        return true;
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get statistics for dashboard
            List<Department> departments = adminService.getAllDepartments();
            List<Doctor> doctors = adminService.getAllDoctors();
            List<Room> rooms = adminService.getAllRooms();
            List<Consultation> consultations = adminService.getAllConsultations();

            request.setAttribute("totalDepartments", departments.size());
            request.setAttribute("totalDoctors", doctors.size());
            request.setAttribute("totalRooms", rooms.size());
            request.setAttribute("totalConsultations", consultations.size());

            request.getRequestDispatcher("/WEB-INF/Views/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-dashboard.jsp").forward(request, response);
        }
    }

    private void showDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Department> departments = adminService.getAllDepartments();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/WEB-INF/Views/admin-departments.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading departments: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-departments.jsp").forward(request, response);
        }
    }

    private void showDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Doctor> doctors = adminService.getAllDoctors();
            List<Department> departments = adminService.getAllDepartments();
            request.setAttribute("doctors", doctors);
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/WEB-INF/Views/admin-doctors.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading doctors: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-doctors.jsp").forward(request, response);
        }
    }

    private void showRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Room> rooms = adminService.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("/WEB-INF/Views/admin-rooms.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading rooms: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-rooms.jsp").forward(request, response);
        }
    }

    private void showConsultations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Consultation> consultations = adminService.getAllConsultations();
            request.setAttribute("consultations", consultations);
            request.getRequestDispatcher("/WEB-INF/Views/admin-consultations.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading consultations: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-consultations.jsp").forward(request, response);
        }
    }

    private void showPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Patient> patients = adminService.getAllPatients();
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("/WEB-INF/Views/admin-patients.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading patients: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-patients.jsp").forward(request, response);
        }
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Generate report data
            int totalConsultations = adminService.getTotalConsultationsCount();
            int pendingConsultations = adminService.getConsultationsCountByStatus(Status.PENDING);
            int validatedConsultations = adminService.getConsultationsCountByStatus(Status.VALIDATED);
            int cancelledConsultations = adminService.getConsultationsCountByStatus(Status.CANCELED);

            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("pendingConsultations", pendingConsultations);
            request.setAttribute("validatedConsultations", validatedConsultations);
            request.setAttribute("cancelledConsultations", cancelledConsultations);

            request.getRequestDispatcher("/WEB-INF/Views/admin-reports.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error generating reports: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/admin-reports.jsp").forward(request, response);
        }
    }

    private void handleDepartmentAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        switch (action) {
            case "create":
                createDepartment(request, response);
                break;
            case "update":
                updateDepartment(request, response);
                break;
            case "delete":
                deleteDepartment(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleDoctorAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        switch (action) {
            case "create":
                createDoctor(request, response);
                break;
            case "update":
                updateDoctor(request, response);
                break;
            case "delete":
                deleteDoctor(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleRoomAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        switch (action) {
            case "create":
                createRoom(request, response);
                break;
            case "update":
                updateRoom(request, response);
                break;
            case "delete":
                deleteRoom(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handlePatientAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        switch (action) {
            case "update":
                updatePatient(request, response);
                break;
            case "delete":
                deletePatient(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");

        Department department = new Department();
        department.setName(name);

        adminService.createDepartment(department);

        request.setAttribute("success", "Department created successfully");
        showDepartments(request, response);
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");

        Department department = new Department();
        department.setId(id);
        department.setName(name);

        adminService.updateDepartment(department);

        request.setAttribute("success", "Department updated successfully");
        showDepartments(request, response);
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Department department = new Department();
        department.setId(id);

        adminService.deleteDepartment(department);

        request.setAttribute("success", "Department deleted successfully");
        showDepartments(request, response);
    }

    private void createDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String specialty = request.getParameter("specialty");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Doctor doctor = new Doctor();
        doctor.setFirstName(firstName);
        doctor.setLastName(lastName);
        doctor.setEmail(email);
        doctor.setPassword("123456");
        doctor.setRole("DOCTOR");
        doctor.setSpecialty(specialty);

        Department department = new Department();
        department.setId(departmentId);
        doctor.setDepartment(department);

        adminService.createDoctor(doctor);

        request.setAttribute("success", "Doctor created successfully");
        showDoctors(request, response);
    }

    private void updateDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String specialty = request.getParameter("specialty");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Doctor doctor = new Doctor();
        doctor.setId(id);
        doctor.setFirstName(firstName);
        doctor.setLastName(lastName);
        doctor.setEmail(email);
        doctor.setPassword("123456");
        doctor.setRole("DOCTOR");
        doctor.setSpecialty(specialty);

        Department department = new Department();
        department.setId(departmentId);
        doctor.setDepartment(department);

        adminService.updateDoctor(doctor);

        request.setAttribute("success", "Doctor updated successfully");
        showDoctors(request, response);
    }

    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Doctor doctor = new Doctor();
        doctor.setId(id);

        adminService.deleteDoctor(doctor);

        request.setAttribute("success", "Doctor deleted successfully");
        showDoctors(request, response);
    }

    private void createRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        int capacity = Integer.parseInt(request.getParameter("capacity"));

        Room room = new Room();
        room.setName(name);
        room.setCapacity(capacity);

        adminService.createRoom(room);

        request.setAttribute("success", "Room created successfully");
        showRooms(request, response);
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int capacity = Integer.parseInt(request.getParameter("capacity"));

        Room room = new Room();
        room.setId(id);
        room.setName(name);
        room.setCapacity(capacity);

        adminService.updateRoom(room);

        request.setAttribute("success", "Room updated successfully");
        showRooms(request, response);
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Room room = new Room();
        room.setId(id);

        adminService.deleteRoom(room);

        request.setAttribute("success", "Room deleted successfully");
        showRooms(request, response);
    }


    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");

        Patient patient = new Patient();
        patient.setId(id);
        patient.setFirstName(firstName);
        patient.setLastName(lastName);
        patient.setEmail(email);
        patient.setPassword("123456");
        patient.setRole("PATIENT");

        if (weightStr != null && !weightStr.isEmpty()) {
            patient.setWeight(Float.parseFloat(weightStr));
        }
        if (heightStr != null && !heightStr.isEmpty()) {
            patient.setHeight(Float.parseFloat(heightStr));
        }

        adminService.updatePatient(patient);

        request.setAttribute("success", "Patient updated successfully");
        showPatients(request, response);
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Patient patient = new Patient();
        patient.setId(id);

        adminService.deletePatient(patient);

        request.setAttribute("success", "Patient deleted successfully");
        showPatients(request, response);
    }
}
