<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hopital_numerique.model.Consultation" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultation Management - Hopital Numerique</title>
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

        .navbar {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: #3b82f6;
            text-decoration: none;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
            align-items: center;
        }

        .nav-item a {
            text-decoration: none;
            color: #64748b;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .nav-item a:hover, .nav-item a.active {
            background: #f1f5f9;
            color: #3b82f6;
        }

        .logout-btn {
            background: #f1f5f9;
            color: #64748b;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .logout-btn:hover {
            background: #ef4444;
            color: white;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
        }

        .content-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .table th {
            background: #f8fafc;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            color: #64748b;
        }

        .table tbody tr:hover {
            background: #f8fafc;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-validated {
            background: #d1fae5;
            color: #065f46;
        }

        .status-canceled {
            background: #fee2e2;
            color: #991b1b;
        }

        .error-message, .success-message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .error-message {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .success-message {
            background: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .main-container {
                padding: 2rem 1rem;
            }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .table-container {
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/admin" class="nav-brand">Hopital Numerique</a>
            <ul class="nav-menu">
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin">Dashboard</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/patients">Patients</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/doctors">Doctors</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/departments">Departments</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/rooms">Rooms</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/consultations" class="active">Consultations</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/reports">Reports</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="main-container">
        <div class="page-header">
            <h1>Consultation Management</h1>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <div class="content-card">
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Room</th>
                            <th>Report</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (consultations != null && !consultations.isEmpty()) {
                                for (Consultation consultation : consultations) {
                        %>
                        <tr>
                            <td><%= consultation.getId() %></td>
                            <td>
                                <%= consultation.getPatient() != null ?
                                    consultation.getPatient().getFirstName() + " " + consultation.getPatient().getLastName() :
                                    "N/A" %>
                            </td>
                            <td>
                                <%= consultation.getDoctor() != null ?
                                    "Dr. " + consultation.getDoctor().getFirstName() + " " + consultation.getDoctor().getLastName() :
                                    "N/A" %>
                            </td>
                            <td><%= consultation.getDate() != null ? consultation.getDate() : "N/A" %></td>
                            <td><%= consultation.getHour() != null ? consultation.getHour() : "N/A" %></td>
                            <td>
                                <%
                                    String status = consultation.getStatus() != null ? consultation.getStatus().toString() : "PENDING";
                                    String statusClass = "";
                                    switch (status) {
                                        case "VALIDATED":
                                            statusClass = "status-validated";
                                            break;
                                        case "CANCELED":
                                            statusClass = "status-canceled";
                                            break;
                                        default:
                                            statusClass = "status-pending";
                                    }
                                %>
                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                            </td>
                            <td>
                                <%= consultation.getRoom() != null ?
                                    consultation.getRoom().getName() :
                                    "Not assigned" %>
                            </td>
                            <td><%= consultation.getReport() != null ?  consultation.getReport() : "N/A" %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 2rem; color: #64748b;">
                                No consultations found
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
