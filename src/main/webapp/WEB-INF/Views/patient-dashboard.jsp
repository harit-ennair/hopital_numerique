<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Patient" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Patient patient = (Patient) user;
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

        .patient-avatar {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            background: #10b981;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .patient-info h2 {
            color: #1e293b;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .patient-info p {
            color: #64748b;
            margin-top: 0.25rem;
        }

        .cta-section {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            color: white;
            padding: 3rem 2rem;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 3rem;
        }

        .cta-section h2 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .cta-section p {
            font-size: 1.125rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .cta-btn {
            display: inline-block;
            background: white;
            color: #3b82f6;
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.125rem;
            transition: all 0.2s ease;
        }

        .cta-btn:hover {
            background: #f8fafc;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
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

            .cta-section {
                padding: 2rem 1rem;
            }

            .cta-section h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/patient" class="nav-brand">Hopital Numerique</a>
            <ul class="nav-menu">
                <li class="nav-item"><a href="<%= request.getContextPath() %>/patient" class="active">Dashboard</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/patient/consultations">My Consultations</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/patient/appointments">Book Appointment</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/patient/profile">Profile</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="main-container">
        <div class="hero-section">
            <h1>Patient Portal</h1>
            <p>Your health journey starts here. Manage appointments and track your medical care</p>
        </div>

        <div class="welcome-card">
            <div class="welcome-header">
                <div class="patient-avatar">
                    <%= patient.getFirstName().substring(0, 1).toUpperCase() %><%= patient.getLastName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="patient-info">
                    <h2><%= patient.getFirstName() %> <%= patient.getLastName() %></h2>
                    <p>Patient ID: #<%= patient.getId() %> •
                        <% if (patient.getWeight() != null && patient.getHeight() != null) { %>
                            <%= patient.getWeight() %>kg, <%= patient.getHeight() %>cm
                        <% } else { %>
                            Profile incomplete
                        <% } %>
                    </p>
                </div>
            </div>
            <p>Welcome to your personal health dashboard. Book appointments, view your consultation history, and manage your medical information all in one place.</p>
        </div>

        <div class="cta-section">
            <h2>Need Medical Care?</h2>
            <p>Book an appointment with our experienced doctors and get the care you deserve</p>
            <a href="<%= request.getContextPath() %>/patient/appointments" class="cta-btn">
                📅 Book Appointment Now
            </a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: #3b82f6;">📅</div>
                <div class="stat-number">3</div>
                <div class="stat-label">Upcoming Appointments</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #10b981;">✅</div>
                <div class="stat-number">12</div>
                <div class="stat-label">Completed Consultations</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #f59e0b;">👨‍⚕️</div>
                <div class="stat-number">5</div>
                <div class="stat-label">Doctors Consulted</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: #8b5cf6;">🏥</div>
                <div class="stat-number">2</div>
                <div class="stat-label">Years as Patient</div>
            </div>
        </div>

        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-grid">
                <a href="<%= request.getContextPath() %>/patient/consultations" class="action-btn">
                    📋 View Consultations
                </a>
                <a href="<%= request.getContextPath() %>/patient/appointments" class="action-btn">
                    📅 Book Appointment
                </a>
                <a href="<%= request.getContextPath() %>/patient/profile" class="action-btn">
                    👤 Update Profile
                </a>
                <a href="<%= request.getContextPath() %>/patient/history" class="action-btn">
                    📊 Medical History
                </a>
            </div>
        </div>
    </div>
</body>
</html>
