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
    String successMessage = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Hopital Numerique</title>
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .page-header {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            text-align: center;
        }

        .page-title {
            font-size: 2rem;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: #64748b;
        }

        .profile-form {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .form-group input {
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .health-info {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .health-info h3 {
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .health-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1rem;
            transition: all 0.2s;
            text-align: center;
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

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .success-message {
            background: #d1fae5;
            color: #059669;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #34d399;
            text-align: center;
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

        .readonly-info {
            background: #f1f5f9;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid #64748b;
            margin-bottom: 2rem;
        }

        .readonly-info h3 {
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .readonly-info p {
            color: #64748b;
            margin-bottom: 0.25rem;
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
            <h1 class="page-title">My Profile</h1>
            <p class="page-subtitle">Manage your personal and health information</p>
        </div>

        <% if ("updated".equals(successMessage)) { %>
        <div class="success-message">
            ✅ Profile updated successfully!
        </div>
        <% } %>

        <div class="readonly-info">
            <h3>Account Information</h3>
            <p><strong>Patient ID:</strong> <%= patient.getId() %></p>
            <p><strong>Role:</strong> <%= patient.getRole() %></p>
        </div>

        <form class="profile-form" action="<%= request.getContextPath() %>/patient" method="post">
            <input type="hidden" name="action" value="update-profile">

            <div class="form-grid">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" value="<%= patient.getFirstName() != null ? patient.getFirstName() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" value="<%= patient.getLastName() != null ? patient.getLastName() : "" %>" required>
                </div>

                <div class="form-group full-width">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= patient.getEmail() != null ? patient.getEmail() : "" %>" required>
                </div>
            </div>

            <div class="health-info">
                <h3>Health Information</h3>
                <div class="health-grid">
                    <div class="form-group">
                        <label for="weight">Weight (kg)</label>
                        <input type="number" id="weight" name="weight" step="0.1" min="0"
                               value="<%= patient.getWeight() > 0 ? patient.getWeight() : "" %>"
                               placeholder="Enter your weight">
                    </div>

                    <div class="form-group">
                        <label for="height">Height (cm)</label>
                        <input type="number" id="height" name="height" step="0.1" min="0"
                               value="<%= patient.getHeight() > 0 ? patient.getHeight() : "" %>"
                               placeholder="Enter your height">
                    </div>
                </div>

                <% if (patient.getWeight() > 0 && patient.getHeight() > 0) { %>
                <%
                    double heightInMeters = patient.getHeight() / 100.0;
                    double bmi = patient.getWeight() / (heightInMeters * heightInMeters);
                    String bmiCategory;
                    if (bmi < 18.5) bmiCategory = "Underweight";
                    else if (bmi < 25) bmiCategory = "Normal weight";
                    else if (bmi < 30) bmiCategory = "Overweight";
                    else bmiCategory = "Obese";
                %>
                <div style="margin-top: 1rem; padding: 1rem; background: white; border-radius: 8px;">
                    <p><strong>BMI:</strong> <%= String.format("%.1f", bmi) %> (<%= bmiCategory %>)</p>
                </div>
                <% } %>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Update Profile</button>
                <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                    <input type="hidden" name="action" value="dashboard">
                    <button type="submit" class="btn btn-secondary">Cancel</button>
                </form>
            </div>
        </form>
    </main>
</body>
</html>
