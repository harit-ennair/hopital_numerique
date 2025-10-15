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
    <title>Admin Dashboard - Hopital Numerique</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>Admin Dashboard</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getFirstName() %> <%= user.getLastName() %></span>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="display: inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </header>

    <div class="container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Doctors</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Departments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Available Rooms</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <h3>Manage Patients</h3>
                <p>View, add, edit, and manage patient records. Monitor patient status and medical history.</p>
                <a href="<%= request.getContextPath() %>/admin/patients" class="card-btn">Manage Patients</a>
            </div>

            <div class="card">
                <h3>Manage Doctors</h3>
                <p>Oversee doctor profiles, schedules, and assign them to departments and specializations.</p>
                <a href="<%= request.getContextPath() %>/admin/doctors" class="card-btn">Manage Doctors</a>
            </div>

            <div class="card">
                <h3>Manage Departments</h3>
                <p>Create and manage hospital departments, assign resources and staff.</p>
                <a href="<%= request.getContextPath() %>/admin/departments" class="card-btn">Manage Departments</a>
            </div>

            <div class="card">
                <h3>Manage Rooms</h3>
                <p>Monitor room availability, assign rooms to patients, and manage room resources.</p>
                <a href="<%= request.getContextPath() %>/admin/rooms" class="card-btn">Manage Rooms</a>
            </div>

            <div class="card">
                <h3>View Consultations</h3>
                <p>Monitor all consultations, appointments, and medical procedures in the hospital.</p>
                <a href="<%= request.getContextPath() %>/admin/consultations" class="card-btn">View Consultations</a>
            </div>

            <div class="card">
                <h3>System Reports</h3>
                <p>Generate comprehensive reports on hospital operations, statistics, and performance.</p>
                <a href="<%= request.getContextPath() %>/admin/reports" class="card-btn">Generate Reports</a>
            </div>
        </div>
    </div>
</body>
</html>

