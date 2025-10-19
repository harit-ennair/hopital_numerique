<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Doctor" %>
<%@ page import="com.example.hopital_numerique.model.Consultation" %>
<%@ page import="com.example.hopital_numerique.model.Status" %>
<%@ page import="java.util.List" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Doctor doctor = (Doctor) user;
    List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultations - Hopital Numerique</title>
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
            margin-bottom: 1.5rem;
        }

        .filter-section {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .filter-select {
            padding: 0.5rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        .success-message {
            background: #d1fae5;
            border: 1px solid #a7f3d0;
            color: #059669;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .consultations-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .consultations-header {
            padding: 1.5rem 2rem;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .consultations-header h2 {
            color: #1e293b;
            font-size: 1.5rem;
        }

        .consultation-card {
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            transition: background 0.2s;
        }

        .consultation-card:hover {
            background: #f8fafc;
        }

        .consultation-card:last-child {
            border-bottom: none;
        }

        .consultation-header {
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

        .consultation-date {
            color: #1e293b;
            font-weight: 500;
            font-size: 1rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-top: 0.5rem;
            display: inline-block;
        }

        .status-pending {
            background: #fef3c7;
            color: #d97706;
        }

        .status-validated {
            background: #ddd6fe;
            color: #7c3aed;
        }

        .status-completed {
            background: #d1fae5;
            color: #059669;
        }

        .status-refused {
            background: #fee2e2;
            color: #dc2626;
        }

        .consultation-details {
            margin-bottom: 1.5rem;
        }

        .consultation-details h4 {
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .consultation-details p {
            color: #64748b;
            line-height: 1.6;
        }

        .report-section {
            background: #f8fafc;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .report-form {
            margin-top: 1rem;
        }

        .report-textarea {
            width: 100%;
            min-height: 100px;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-family: inherit;
            resize: vertical;
        }

        .consultation-actions {
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

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-success:hover {
            background: #059669;
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
            <h1 class="page-title">My Consultations</h1>
            <p class="page-subtitle">Manage your consultations and add medical reports</p>

            <div class="filter-section">
                <label for="statusFilter">Filter by Status:</label>
                <form method="get" action="<%= request.getContextPath() %>/doctor/consultations">
                    <select name="status" class="filter-select" onchange="this.form.submit()">
                        <option value="">All Consultations</option>
                        <option value="PENDING" <%= "PENDING".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                        <option value="VALIDATED" <%= "VALIDATED".equals(statusFilter) ? "selected" : "" %>>Validated</option>
                        <option value="COMPLETED" <%= "COMPLETED".equals(statusFilter) ? "selected" : "" %>>Completed</option>
                        <option value="REFUSED" <%= "REFUSED".equals(statusFilter) ? "selected" : "" %>>Refused</option>
                    </select>
                </form>
            </div>
        </div>

        <% if ("report_added".equals(success)) { %>
        <div class="success-message">
            ✓ Consultation report has been added successfully!
        </div>
        <% } else if ("report_updated".equals(success)) { %>
        <div class="success-message">
            ✓ Consultation report has been updated successfully!
        </div>
        <% } else if ("status_updated".equals(success)) { %>
        <div class="success-message">
            ✓ Consultation status has been updated successfully!
        </div>
        <% } %>

        <div class="consultations-container">
            <div class="consultations-header">
                <h2>Consultation History</h2>
            </div>

            <% if (consultations != null && !consultations.isEmpty()) { %>
                <% for (Consultation consultation : consultations) { %>
                <div class="consultation-card">
                    <div class="consultation-header">
                        <div class="patient-info">
                            <h3><%= consultation.getPatient().getFirstName() %> <%= consultation.getPatient().getLastName() %></h3>
                            <p>Patient ID: <%= consultation.getPatient().getId() %></p>
                            <p>Email: <%= consultation.getPatient().getEmail() %></p>
                        </div>
                        <div>
                            <div class="consultation-date"><%= consultation.getDate() %></div>
                            <span class="status-badge status-<%= consultation.getStatus().toString().toLowerCase() %>">
                                <%= consultation.getStatus() %>
                            </span>
                        </div>
                    </div>

                    <% if (consultation.getReport() != null && !consultation.getReport().trim().isEmpty()) { %>
                    <div class="consultation-details">
                        <h4>Reason for Consultation:</h4>
                        <p><%= consultation.getReport() %></p>
                    </div>
                    <% } %>

                    <% if (consultation.getReport() != null && !consultation.getReport().trim().isEmpty()) { %>
                    <div class="report-section">
                        <h4>Medical Report:</h4>
                        <p><%= consultation.getReport() %></p>
                    </div>
                    <% } %>

                    <% if (consultation.getStatus() == Status.VALIDATED || consultation.getStatus() == Status.COMPLETED) { %>
                    <div class="consultation-actions">
                        <% if (consultation.getStatus() == Status.VALIDATED) { %>
                        <form method="post" action="<%= request.getContextPath() %>/doctor/add-report" style="display: inline;">
                            <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                            <div class="report-form">
                                <textarea name="report" class="report-textarea" placeholder="Add medical report..." required></textarea>
                                <button type="submit" class="btn btn-success" style="margin-top: 0.5rem;">
                                    📝 Add Report & Complete
                                </button>
                            </div>
                        </form>
                        <% } else if (consultation.getStatus() == Status.COMPLETED) { %>
                        <form method="post" action="<%= request.getContextPath() %>/doctor/update-report" style="display: inline;">
                            <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                            <div class="report-form">
                                <textarea name="report" class="report-textarea" placeholder="Update medical report..."><%= consultation.getReport() != null ? consultation.getReport() : "" %></textarea>
                                <button type="submit" class="btn btn-primary" style="margin-top: 0.5rem;">
                                    ✏️ Update Report
                                </button>
                            </div>
                        </form>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                <% } %>
            <% } else { %>
            <div class="empty-state">
                <h3>No Consultations Found</h3>
                <p>You don't have any consultations <%= statusFilter != null ? "with status " + statusFilter : "" %> at the moment.</p>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
