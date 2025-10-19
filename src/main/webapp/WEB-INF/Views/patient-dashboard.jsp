<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Patient" %>
<%@ page import="com.example.hopital_numerique.model.Consultation" %>
<%@ page import="java.util.List" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Patient patient = (Patient) user;

    Long totalConsultations = (Long) request.getAttribute("totalConsultations");
    Long pendingCount = (Long) request.getAttribute("pendingCount");
    Long completedCount = (Long) request.getAttribute("completedCount");
    Long validatedCount = (Long) request.getAttribute("validatedCount");
    List<Consultation> recentConsultations = (List<Consultation>) request.getAttribute("recentConsultations");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Hopital Numerique</title>
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
            display: grid;
            gap: 2rem;
        }

        .welcome-section {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .welcome-title {
            font-size: 2rem;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            color: #64748b;
            font-size: 1.1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 4px solid;
        }

        .stat-card.total { border-left-color: #06b6d4; }
        .stat-card.pending { border-left-color: #f59e0b; }
        .stat-card.completed { border-left-color: #10b981; }
        .stat-card.validated { border-left-color: #8b5cf6; }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .stat-card.total .stat-number { color: #06b6d4; }
        .stat-card.pending .stat-number { color: #f59e0b; }
        .stat-card.completed .stat-number { color: #10b981; }
        .stat-card.validated .stat-number { color: #8b5cf6; }

        .stat-label {
            color: #64748b;
            font-size: 1rem;
        }

        .navigation-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .nav-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .nav-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            text-decoration: none;
            color: inherit;
        }

        .nav-card h3 {
            color: #1e293b;
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }

        .nav-card p {
            color: #64748b;
            margin-bottom: 1rem;
        }

        .nav-card .nav-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .recent-consultations {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .recent-consultations h2 {
            color: #1e293b;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .consultation-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .consultation-info h4 {
            color: #1e293b;
            margin-bottom: 0.25rem;
        }

        .consultation-info p {
            color: #64748b;
            font-size: 0.9rem;
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
            <div class="user-info">
                <span>Welcome, <%= patient.getFirstName() %> <%= patient.getLastName() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <section class="welcome-section">
            <h1 class="welcome-title">Patient Dashboard</h1>
            <p class="welcome-subtitle">Manage your medical consultations and health information</p>
        </section>

        <section class="stats-grid">
            <div class="stat-card total">
                <div class="stat-number"><%= totalConsultations != null ? totalConsultations : 0 %></div>
                <div class="stat-label">Total Consultations</div>
            </div>
            <div class="stat-card pending">
                <div class="stat-number"><%= pendingCount != null ? pendingCount : 0 %></div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card completed">
                <div class="stat-number"><%= completedCount != null ? completedCount : 0 %></div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card validated">
                <div class="stat-number"><%= validatedCount != null ? validatedCount : 0 %></div>
                <div class="stat-label">Validated</div>
            </div>
        </section>

        <section class="navigation-grid">
            <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                <input type="hidden" name="action" value="consultations">
                <button type="submit" class="nav-card" style="border: none; background: none; width: 100%; cursor: pointer;">
                    <div class="nav-icon">📋</div>
                    <h3>My Consultations</h3>
                    <p>View your consultation history and status</p>
                </button>
            </form>

            <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                <input type="hidden" name="action" value="book-consultation">
                <button type="submit" class="nav-card" style="border: none; background: none; width: 100%; cursor: pointer;">
                    <div class="nav-icon">📅</div>
                    <h3>Book Consultation</h3>
                    <p>Schedule a new medical consultation</p>
                </button>
            </form>

            <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                <input type="hidden" name="action" value="profile">
                <button type="submit" class="nav-card" style="border: none; background: none; width: 100%; cursor: pointer;">
                    <div class="nav-icon">👤</div>
                    <h3>My Profile</h3>
                    <p>Update your personal information</p>
                </button>
            </form>
        </section>

        <% if (recentConsultations != null && !recentConsultations.isEmpty()) { %>
        <section class="recent-consultations">
            <h2>Recent Consultations</h2>
            <% for (Consultation consultation : recentConsultations) { %>
            <div class="consultation-item">
                <div class="consultation-info">
                    <h4>Dr. <%= consultation.getDoctor() != null ? consultation.getDoctor().getFirstName() + " " + consultation.getDoctor().getLastName() : "Unknown" %></h4>
                    <p><%= consultation.getDate() %> at <%= consultation.getHour() %></p>
                </div>
                <span class="status-badge status-<%= consultation.getStatus().toString().toLowerCase() %>">
                    <%= consultation.getStatus().toString() %>
                </span>
            </div>
            <% } %>
        </section>
        <% } %>
    </main>
</body>
</html>
