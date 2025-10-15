
package com.example.hopital_numerique.controller;

import com.example.hopital_numerique.dao.*;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Person;
import com.example.hopital_numerique.services.PatientServ;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/signup", "/logout", "/dashboard"})
public class AuthServlet extends HttpServlet {
    private PatientServ patientService;
    private PatientDao patientDao;
    private DoctorDao doctorDao;
    private PersonDao personDao;

    @Override
    public void init() throws ServletException {
        this.patientDao = new PatientDao();
        this.doctorDao = new DoctorDao();
        this.personDao = new PersonDao();
        this.patientService = new PatientServ(
                new ConsulltationDao(),
                doctorDao,
                new RoomDao(),
                patientDao
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
                break;
            case "/signup":
                request.getRequestDispatcher("/WEB-INF/Views/signup.jsp").forward(request, response);
                break;
            case "/dashboard":
                redirectToDashboard(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/signup":
                handleSignup(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {

            Person person = personDao.findByEmail(email);

            if (person != null && person.getPassword().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", person);

                redirectByRole(person, request, response);
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error during login: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");

        try {
            float weight = Float.parseFloat(weightStr);
            float height = Float.parseFloat(heightStr);

//             Check if email already exists

            Person existingPerson = personDao.findByEmail(email);

            if (existingPerson != null) {
                request.setAttribute("error", "Email already exists. Please use a different email.");
                request.getRequestDispatcher("/WEB-INF/Views/signup.jsp").forward(request, response);
                return;
            }

            Patient newPatient = new Patient(firstName, lastName, email, password, "PATIENT", weight, height, null);
            Patient savedPatient = patientService.addPatient(newPatient);

            if (savedPatient != null) {
                request.setAttribute("success", "Account created successfully! Please login.");
                request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to create account. Please try again.");
                request.getRequestDispatcher("/WEB-INF/Views/signup.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter valid weight and height values.");
            request.getRequestDispatcher("/WEB-INF/Views/signup.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error during signup: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Views/signup.jsp").forward(request, response);
        }
    }

    private void redirectByRole(Person person, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = person.getRole();

        switch (role) {
            case "ADMIN":
                request.getRequestDispatcher("/WEB-INF/Views/admin-dashboard.jsp").forward(request, response);
                break;
            case "DOCTOR":
                request.getRequestDispatcher("/WEB-INF/Views/doctor-dashboard.jsp").forward(request, response);
                break;
            case "PATIENT":
                request.getRequestDispatcher("/WEB-INF/Views/patient-dashboard.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            Person user = (Person) session.getAttribute("user");
            redirectByRole(user, request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
