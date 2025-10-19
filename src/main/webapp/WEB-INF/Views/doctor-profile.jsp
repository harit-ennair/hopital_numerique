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
    <title>Doctor Profile - Hopital Numerique</title>
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

        .profile-container {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }

        .profile-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            margin: 0 auto 1.5rem;
        }

        .profile-name {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-name h2 {
            color: #1e293b;
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }

        .profile-name p {
            color: #64748b;
            font-size: 1rem;
        }

        .profile-info {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 8px;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #3b82f6;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .info-content h4 {
            color: #374151;
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .info-content p {
            color: #1e293b;
            font-size: 1rem;
            font-weight: 500;
        }

        .details-section {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .details-section h3 {
            color: #1e293b;
            font-size: 1.25rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .detail-item {
            padding: 1rem;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 4px solid #3b82f6;
        }

        .detail-item h4 {
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .detail-item p {
            color: #1e293b;
            font-size: 1rem;
            font-weight: 500;
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

        @media (max-width: 768px) {
            .profile-container {
                grid-template-columns: 1fr;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }
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
            <h1 class="page-title">My Profile</h1>
            <p class="page-subtitle">View your professional information and details</p>
        </div>

        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-avatar">
                    👨‍⚕️
                </div>
                <div class="profile-name">
                    <h2>Dr. <%= doctor.getFirstName() %> <%= doctor.getLastName() %></h2>
                    <p>Medical Doctor</p>
                </div>

                <div class="profile-info">
                    <div class="info-item">
                        <div class="info-icon">📧</div>
                        <div class="info-content">
                            <h4>Email Address</h4>
                            <p><%= doctor.getEmail() %></p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">🏥</div>
                        <div class="info-content">
                            <h4>Department</h4>
                            <p><%= doctor.getDepartment() != null ? doctor.getDepartment().getName() : "Not assigned" %></p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">🆔</div>
                        <div class="info-content">
                            <h4>Doctor ID</h4>
                            <p>#<%= doctor.getId() %></p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="details-section">
                <h3>Professional Details</h3>
                <div class="details-grid">
                    <div class="detail-item">
                        <h4>Full Name</h4>
                        <p><%= doctor.getFirstName() %> <%= doctor.getLastName() %></p>
                    </div>

                    <div class="detail-item">
                        <h4>Email</h4>
                        <p><%= doctor.getEmail() %></p>
                    </div>


                    <div class="detail-item">
                        <h4>Department</h4>
                        <p><%= doctor.getDepartment() != null ? doctor.getDepartment().getName() : "Not assigned" %></p>
                    </div>

                    <div class="detail-item">
                        <h4>Specialization</h4>
                        <p><%= doctor.getSpecialty() != null ? doctor.getSpecialty() : "General Practice" %></p>
                    </div>

                    <div class="detail-item">
                        <h4>Employee ID</h4>
                        <p>#<%= doctor.getId() %></p>
                    </div>

                    <div class="detail-item">
                        <h4>Role</h4>
                        <p><%= doctor.getRole() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
