<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Hopital Numerique</title>
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
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .page-header p {
            font-size: 1.125rem;
            color: #64748b;
        }

        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .report-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: all 0.2s ease;
        }

        .report-card:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .report-icon {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1.5rem;
            color: white;
        }

        .report-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .report-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .report-label {
            color: #64748b;
            font-size: 0.875rem;
        }

        .chart-section {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .chart-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 2rem;
            text-align: center;
        }

        .chart-placeholder {
            height: 300px;
            background: #f8fafc;
            border: 2px dashed #e2e8f0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 1.125rem;
        }

        .error-message {
            background: #fef2f2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #fecaca;
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .main-container {
                padding: 2rem 1rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .reports-grid {
                grid-template-columns: 1fr;
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
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/consultations">Consultations</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/reports" class="active">Reports</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="main-container">
        <div class="page-header">
            <h1>Hospital Reports</h1>
            <p>Comprehensive analytics and insights for hospital management</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="reports-grid">
            <div class="report-card">
                <div class="report-icon" style="background: #3b82f6;">📊</div>
                <div class="report-title">Total Consultations</div>
                <div class="report-value" style="color: #3b82f6;">
                    <%= request.getAttribute("totalConsultations") != null ? request.getAttribute("totalConsultations") : 0 %>
                </div>
                <div class="report-label">All time consultations</div>
            </div>

            <div class="report-card">
                <div class="report-icon" style="background: #f59e0b;">⏳</div>
                <div class="report-title">Pending Consultations</div>
                <div class="report-value" style="color: #f59e0b;">
                    <%= request.getAttribute("pendingConsultations") != null ? request.getAttribute("pendingConsultations") : 0 %>
                </div>
                <div class="report-label">Awaiting confirmation</div>
            </div>

            <div class="report-card">
                <div class="report-icon" style="background: #10b981;">✅</div>
                <div class="report-title">Validated Consultations</div>
                <div class="report-value" style="color: #10b981;">
                    <%= request.getAttribute("validatedConsultations") != null ? request.getAttribute("validatedConsultations") : 0 %>
                </div>
                <div class="report-label">Confirmed appointments</div>
            </div>

            <div class="report-card">
                <div class="report-icon" style="background: #ef4444;">❌</div>
                <div class="report-title">Cancelled Consultations</div>
                <div class="report-value" style="color: #ef4444;">
                    <%= request.getAttribute("cancelledConsultations") != null ? request.getAttribute("cancelledConsultations") : 0 %>
                </div>
                <div class="report-label">Cancelled appointments</div>
            </div>
        </div>

        <div class="chart-section">
            <h2 class="chart-title">Consultation Status Overview</h2>
            <div class="chart-placeholder">
                📈 Chart visualization would be displayed here<br>
                <small>Integrate with Chart.js or similar library for dynamic charts</small>
            </div>
        </div>
    </div>
</body>
</html>
