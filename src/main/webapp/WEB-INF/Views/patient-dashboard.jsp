<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
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
            font-family: 'Arial', sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 1.5rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            color: #333;
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }

        .card p {
            color: #666;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }

        .card-btn {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: transform 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .card-btn:hover {
            transform: translateY(-2px);
        }

        .welcome-card {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            grid-column: 1 / -1;
            margin-bottom: 2rem;
        }

        .welcome-card h2 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .welcome-card p {
            color: rgba(255,255,255,0.9);
            font-size: 1.1rem;
        }

        .appointments-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            grid-column: 1 / -1;
        }

        .appointments-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .appointment-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            border-left: 4px solid #3498db;
            background: #f8f9fa;
            margin-bottom: 1rem;
            border-radius: 8px;
        }

        .appointment-date {
            font-weight: bold;
            color: #3498db;
        }

        .appointment-doctor {
            color: #333;
            flex-grow: 1;
            margin-left: 1rem;
        }

        .appointment-status {
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            background: #e8f5e8;
            color: #2ecc71;
        }

        .health-summary {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .health-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .health-label {
            color: #666;
        }

        .health-value {
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>Patient Dashboard</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getFirstName() %> <%= user.getLastName() %></span>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="display: inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <div class="container">
        <div class="welcome-card card">
            <h2>Welcome to Your Health Portal</h2>
            <p>Manage your appointments, view medical records, and stay connected with your healthcare team.</p>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <h3>Book Appointment</h3>
                <p>Schedule a new appointment with available doctors. Choose your preferred date and time.</p>
                <a href="<%= request.getContextPath() %>/patient/book-appointment" class="card-btn">Book Now</a>
            </div>

            <div class="card">
                <h3>My Appointments</h3>
                <p>View your upcoming and past appointments. Manage your scheduled visits with doctors.</p>
                <a href="<%= request.getContextPath() %>/patient/appointments" class="card-btn">View Appointments</a>
            </div>

            <div class="card">
                <h3>Medical Records</h3>
                <p>Access your medical history, test results, prescriptions, and treatment summaries.</p>
                <a href="<%= request.getContextPath() %>/patient/records" class="card-btn">View Records</a>
            </div>

            <div class="card">
                <h3>My Profile</h3>
                <p>Update your personal information, contact details, and health profile.</p>
                <div class="health-summary">
                    <div class="health-item">
                        <span class="health-label">Email:</span>
                        <span class="health-value"><%= user.getEmail() %></span>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/patient/profile" class="card-btn">Edit Profile</a>
            </div>

            <div class="card">
                <h3>Prescriptions</h3>
                <p>View active prescriptions, medication schedules, and pharmacy information.</p>
                <a href="<%= request.getContextPath() %>/patient/prescriptions" class="card-btn">View Prescriptions</a>
            </div>

            <div class="card">
                <h3>Health Resources</h3>
                <p>Access health tips, educational materials, and wellness programs.</p>
                <a href="<%= request.getContextPath() %>/patient/resources" class="card-btn">Explore Resources</a>
            </div>
        </div>

        <div class="appointments-card">
            <div class="appointments-header">
                <h3>Upcoming Appointments</h3>
                <a href="<%= request.getContextPath() %>/patient/book-appointment" class="card-btn">Book New</a>
            </div>

            <div class="appointment-item">
                <div class="appointment-date">No upcoming appointments</div>
                <div class="appointment-doctor">Schedule your next visit with a doctor</div>
                <div class="appointment-status">Available</div>
            </div>

            <div style="text-align: center; margin-top: 1rem;">
                <a href="<%= request.getContextPath() %>/patient/appointments" class="card-btn">View All Appointments</a>
            </div>
        </div>
    </div>
</body>
</html>

