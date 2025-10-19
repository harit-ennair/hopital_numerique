<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Patient" %>
<%@ page import="com.example.hopital_numerique.model.Consultation" %>
<%@ page import="com.example.hopital_numerique.model.Status" %>
<%@ page import="java.util.List" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Patient patient = (Patient) user;

    List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String successMessage = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Consultations - Hopital Numerique</title>
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
            background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 2rem;
            color: #1e293b;
        }

        .filters {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .filter-form {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .filter-select {
            padding: 0.5rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: white;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #06b6d4;
            color: white;
        }

        .btn-primary:hover {
            background: #0891b2;
        }

        .btn-secondary {
            background: #64748b;
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
        }

        .btn-danger {
            background: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .consultations-grid {
            display: grid;
            gap: 1.5rem;
        }

        .consultation-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border-left: 4px solid #06b6d4;
        }

        .consultation-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }

        .consultation-info h3 {
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .consultation-info p {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
        }

        .consultation-actions {
            display: flex;
            gap: 0.5rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
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

        .success-message {
            background: #d1fae5;
            color: #059669;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #34d399;
        }

        .empty-state {
            background: white;
            padding: 4rem 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            text-align: center;
        }

        .empty-state h3 {
            color: #64748b;
            margin-bottom: 1rem;
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

        .back-btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.2s;
            margin-right: 1rem;
        }

        .back-btn:hover {
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
            <div class="user-info">
                <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                    <input type="hidden" name="action" value="dashboard">
                    <button type="submit" class="back-btn">← Dashboard</button>
                </form>
                <span>Welcome, <%= patient.getFirstName() %> <%= patient.getLastName() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <h1 class="page-title">My Consultations</h1>
            <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                <input type="hidden" name="action" value="book-consultation">
                <button type="submit" class="btn btn-primary">📅 Book New Consultation</button>
            </form>
        </div>

        <% if ("booked".equals(successMessage)) { %>
        <div class="success-message">
            ✅ Consultation booked successfully!
        </div>
        <% } else if ("cancelled".equals(successMessage)) { %>
        <div class="success-message">
            ✅ Consultation cancelled successfully!
        </div>
        <% } %>

        <div class="filters">
            <form class="filter-form" action="<%= request.getContextPath() %>/patient" method="get">
                <input type="hidden" name="action" value="consultations">
                <label for="status">Filter by status:</label>
                <select name="status" id="status" class="filter-select">
                    <option value="">All Consultations</option>
                    <option value="PENDING" <%= "PENDING".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                    <option value="VALIDATED" <%= "VALIDATED".equals(statusFilter) ? "selected" : "" %>>Validated</option>
                    <option value="COMPLETED" <%= "COMPLETED".equals(statusFilter) ? "selected" : "" %>>Completed</option>
                    <option value="REFUSED" <%= "REFUSED".equals(statusFilter) ? "selected" : "" %>>Refused</option>
                </select>
                <button type="submit" class="btn btn-secondary">Filter</button>
            </form>
        </div>

        <div class="consultations-grid">
            <% if (consultations != null && !consultations.isEmpty()) { %>
                <% for (Consultation consultation : consultations) { %>
                <div class="consultation-card">
                    <div class="consultation-header">
                        <div class="consultation-info">
                            <h3>Consultation with Dr. <%= consultation.getDoctor() != null ? consultation.getDoctor().getFirstName() + " " + consultation.getDoctor().getLastName() : "Unknown" %></h3>
                            <p><strong>Date:</strong> <%= consultation.getDate() %></p>
                            <p><strong>Time:</strong> <%= consultation.getHour() %></p>
                            <p><strong>Room:</strong> <%= consultation.getRoom() != null ? consultation.getRoom().getId() : "Not assigned" %></p>
                            <% if (consultation.getReport() != null && !consultation.getReport().trim().isEmpty()) { %>
                            <p><strong>Diagnosis:</strong> <%= consultation.getReport() %></p>
                            <% } %>
                        </div>
                        <div class="consultation-actions">
                            <span class="status-badge status-<%= consultation.getStatus().toString().toLowerCase() %>">
                                <%= consultation.getStatus().toString() %>
                            </span>
                            <% if (consultation.getStatus() == Status.PENDING) { %>
                            <form action="<%= request.getContextPath() %>/patient" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="cancel-consultation">
                                <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this consultation?')">Cancel</button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            <% } else { %>
            <div class="empty-state">
                <h3>No consultations found</h3>
                <p>You haven't booked any consultations yet or no consultations match your filter.</p>
                <br>
                <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                    <input type="hidden" name="action" value="book-consultation">
                    <button type="submit" class="btn btn-primary">Book Your First Consultation</button>
                </form>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>
