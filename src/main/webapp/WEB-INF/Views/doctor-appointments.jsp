<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Doctor" %>
<%@ page import="com.example.hopital_numerique.model.Consultation" %>
<%@ page import="java.util.List" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Doctor doctor = (Doctor) user;
    List<Consultation> appointments = (List<Consultation>) request.getAttribute("appointments");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Hopital Numerique</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            line-height: 1.6;
            color: #334155;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 1rem;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: background 0.2s;
        }

        .nav-links a:hover {
            background: rgba(255,255,255,0.2);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .main-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .page-header {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 1.1rem;
        }

        .success-message {
            background: #d1fae5;
            border: 1px solid #a7f3d0;
            color: #059669;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .appointments-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .appointments-header {
            padding: 1.5rem 2rem;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .appointments-header h2 {
            color: #1e293b;
            font-size: 1.5rem;
        }

        .appointment-card {
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            transition: background 0.2s;
        }

        .appointment-card:hover {
            background: #f8fafc;
        }

        .appointment-card:last-child {
            border-bottom: none;
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .patient-info h3 {
            color: #1e293b;
            font-size: 1.25rem;
            margin-bottom: 0.25rem;
        }

        .patient-info p {
            color: #64748b;
            font-size: 0.9rem;
        }

        .appointment-date {
            color: #1e293b;
            font-weight: 500;
            font-size: 1rem;
        }

        .appointment-details {
            margin-bottom: 1.5rem;
        }

        .appointment-details h4 {
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .appointment-details p {
            color: #64748b;
            line-height: 1.6;
        }

        .appointment-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-validate {
            background: #10b981;
            color: white;
        }

        .btn-validate:hover {
            background: #059669;
        }

        .btn-refuse {
            background: #ef4444;
            color: white;
        }

        .btn-refuse:hover {
            background: #dc2626;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #64748b;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            font-size: 1rem;
        }

        .logout-btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.2s;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
            text-decoration: none;
            color: white;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            background: #fef3c7;
            color: #d97706;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">🏥 Hopital Numerique</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/doctor/dashboard">Dashboard</a>
                <a href="<%= request.getContextPath() %>/doctor/appointments">Appointments</a>
                <a href="<%= request.getContextPath() %>/doctor/consultations">Consultations</a>
                <a href="<%= request.getContextPath() %>/doctor/profile">Profile</a>
            </div>
            <div class="user-info">
                <span>Dr. <%= doctor.getFirstName() %> <%= doctor.getLastName() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Pending Appointments</h1>
            <p class="page-subtitle">Review and manage your pending appointment requests</p>
        </div>

        <% if ("validated".equals(success)) { %>
        <div class="success-message">
            ✓ Appointment has been validated successfully!
        </div>
        <% } else if ("refused".equals(success)) { %>
        <div class="success-message">
            ✓ Appointment has been refused successfully!
        </div>
        <% } %>

        <div class="appointments-container">
            <div class="appointments-header">
                <h2>Appointment Requests</h2>
            </div>

            <% if (appointments != null && !appointments.isEmpty()) { %>
                <% for (Consultation appointment : appointments) { %>
                <div class="appointment-card">
                    <div class="appointment-header">
                        <div class="patient-info">
                            <h3><%= appointment.getPatient().getFirstName() %> <%= appointment.getPatient().getLastName() %></h3>
                            <p>Patient ID: <%= appointment.getPatient().getId() %></p>
                            <p>Email: <%= appointment.getPatient().getEmail() %></p>
                        </div>
                        <div>
                            <div class="appointment-date"><%= appointment.getDate() %></div>
                            <span class="status-badge"><%= appointment.getStatus() %></span>
                        </div>
                    </div>

                    <% if (appointment.getStatus() != null) { %>
                    <div class="appointment-details">
                        <h4>Reason for Consultation:</h4>
                        <p><%= appointment.getReport() %></p>
                    </div>
                    <% } %>

                    <div class="appointment-actions">
                        <form method="post" action="<%= request.getContextPath() %>/doctor/validate-consultation" style="display: inline;">
                            <input type="hidden" name="consultationId" value="<%= appointment.getId() %>">
                            <button type="submit" class="btn btn-validate">
                                ✓ Validate Appointment
                            </button>
                        </form>
                        <form method="post" action="<%= request.getContextPath() %>/doctor/refuse-consultation" style="display: inline;">
                            <input type="hidden" name="consultationId" value="<%= appointment.getId() %>">
                            <button type="submit" class="btn btn-refuse" onclick="return confirm('Are you sure you want to refuse this appointment?')">
                                ✗ Refuse Appointment
                            </button>
                        </form>
                    </div>
                </div>
                <% } %>
            <% } else { %>
            <div class="empty-state">
                <h3>No Pending Appointments</h3>
                <p>You don't have any pending appointment requests at the moment.</p>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
