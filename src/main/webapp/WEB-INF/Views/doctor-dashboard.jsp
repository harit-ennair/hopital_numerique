<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Doctor" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Doctor doctor = (Doctor) user;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - Hopital Numerique</title>
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

        .hero-section {
            text-align: center;
            margin-bottom: 4rem;
        }

        .hero-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 1rem;
            letter-spacing: -0.025em;
        }

        .hero-section p {
            font-size: 1.125rem;
            color: #64748b;
            max-width: 600px;
            margin: 0 auto;
        }

        .welcome-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 3rem;
        }

        .welcome-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .doctor-avatar {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            background: #3b82f6;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .doctor-info h2 {
            color: #1e293b;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .doctor-info p {
            color: #64748b;
            margin-top: 0.25rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: all 0.2s ease;
        }

        .stat-card:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 1rem;
            color: white;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #64748b;
            font-size: 0.875rem;
        }

        .quick-actions {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .quick-actions h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 1rem;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            text-decoration: none;
            color: #334155;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .action-btn:hover {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .main-container {
                padding: 2rem 1rem;
            }

            .hero-section h1 {
                font-size: 2rem;
            }

            .welcome-header {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/doctor" class="nav-brand">Hopital Numerique</a>
            <ul class="nav-menu">
                <li class="nav-item"><a href="<%= request.getContextPath() %>/doctor" class="active">Dashboard</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/doctor/consultations">My Consultations</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/doctor/schedule">Schedule</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="main-container">
        <div class="hero-section">
            <h1>Doctor Portal</h1>
            <p>Manage your consultations and patient appointments efficiently</p>
        </div>

        <div class="welcome-card">
            <div class="welcome-header">
                <div class="doctor-avatar">
                    <%= doctor.getFirstName().substring(0, 1).toUpperCase() %><%= doctor.getLastName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="doctor-info">
                    <h2>Dr. <%= doctor.getFirstName() %> <%= doctor.getLastName() %></h2>
                    <p><%= doctor.getSpecialty() %> • <%= doctor.getDepartment() != null ? doctor.getDepartment().getName() : "General" %> Department</p>
                </div>
            </div>
            <p>Welcome to your personalized dashboard. Here you can view your upcoming consultations, manage your schedule, and access patient information.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: #3b82f6;">📅</div>
                <div class="stat-number">12</div>
                <div class="stat-label">Today's Appointments</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #10b981;">✅</div>
                <div class="stat-number">8</div>
                <div class="stat-label">Completed Today</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #f59e0b;">⏰</div>
                <div class="stat-number">4</div>
                <div class="stat-label">Upcoming</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #8b5cf6;">👥</div>
                <div class="stat-number">156</div>
                <div class="stat-label">Total Patients</div>
            </div>
        </div>

        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-grid">
                <a href="<%= request.getContextPath() %>/doctor/consultations" class="action-btn">
                    📋 View Consultations
                </a>
                <a href="<%= request.getContextPath() %>/doctor/schedule" class="action-btn">
                    📅 Manage Schedule
                </a>
                <a href="<%= request.getContextPath() %>/doctor/patients" class="action-btn">
                    👥 Patient Records
                </a>
                <a href="<%= request.getContextPath() %>/doctor/reports" class="action-btn">
                    📊 Generate Reports
                </a>
            </div>
        </div>
    </div>
</body>
</html>
