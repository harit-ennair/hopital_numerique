<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
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
            font-family: 'Arial', sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
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
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #2ecc71;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        .schedule-card {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            grid-column: 1 / -1;
        }

        .schedule-header {
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
            border-left: 4px solid #2ecc71;
            background: #f8f9fa;
            margin-bottom: 1rem;
            border-radius: 8px;
        }

        .appointment-time {
            font-weight: bold;
            color: #2ecc71;
        }

        .appointment-patient {
            color: #333;
            flex-grow: 1;
            margin-left: 1rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>Doctor Dashboard</h1>
        <div class="user-info">
            <span>Dr. <%= user.getFirstName() %> <%= user.getLastName() %></span>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="display: inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <div class="container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Today's Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Pending Consultations</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Completed Today</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <h3>My Patients</h3>
                <p>View and manage your assigned patients, review medical histories and treatment plans.</p>
                <a href="<%= request.getContextPath() %>/doctor/patients" class="card-btn">View Patients</a>
            </div>

            <div class="card">
                <h3>Consultations</h3>
                <p>Schedule new consultations, review upcoming appointments, and manage patient visits.</p>
                <a href="<%= request.getContextPath() %>/doctor/consultations" class="card-btn">Manage Consultations</a>
            </div>

            <div class="card">
                <h3>Medical Records</h3>
                <p>Access and update patient medical records, add diagnoses, and prescribe treatments.</p>
                <a href="<%= request.getContextPath() %>/doctor/records" class="card-btn">Medical Records</a>
            </div>

            <div class="card">
                <h3>Schedule</h3>
                <p>View your daily schedule, manage availability, and handle appointment requests.</p>
                <a href="<%= request.getContextPath() %>/doctor/schedule" class="card-btn">View Schedule</a>
            </div>

            <div class="schedule-card">
                <div class="schedule-header">
                    <h3>Today's Schedule</h3>
                    <span style="color: #666; font-size: 0.9rem;">
                        <%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
                    </span>
                </div>

                <div class="appointment-item">
                    <div class="appointment-time">09:00 AM</div>
                    <div class="appointment-patient">No appointments scheduled</div>
                </div>

                <div style="text-align: center; margin-top: 1rem;">
                    <a href="<%= request.getContextPath() %>/doctor/schedule" class="card-btn">View Full Schedule</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

