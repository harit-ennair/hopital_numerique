<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.hopital_numerique.model.Patient" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management - Hopital Numerique</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
        }

        .content-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .table th {
            background: #f8fafc;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            color: #64748b;
        }

        .table tbody tr:hover {
            background: #f8fafc;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            border: none;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 0.875rem;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
            color: white;
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #374151;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-group {
            display: flex;
            gap: 0.5rem;
        }

        .error-message {
            background: #fef2f2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #fecaca;
        }

        .success-message {
            background: #f0fdf4;
            color: #16a34a;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #bbf7d0;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            top: -20%;
            background: white;
            max-width: 500px;
            margin: 10% auto;
            padding: 2rem;
            border-radius: 12px;
            position: relative;
        }

        .modal-header {
            margin-bottom: 1.5rem;
        }

        .modal-header h2 {
            color: #1e293b;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.875rem;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.2s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .close {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #64748b;
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .main-container {
                padding: 2rem 1rem;
            }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .table-container {
                font-size: 0.875rem;
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
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/patients" class="active">Patients</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/doctors">Doctors</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/departments">Departments</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/rooms">Rooms</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/consultations">Consultations</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/reports">Reports</a></li>
                <li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="main-container">
        <div class="page-header">
            <h1>Patient Management</h1>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <div class="content-card">
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Weight</th>
                            <th>Height</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (patients != null && !patients.isEmpty()) {
                                for (Patient patient : patients) {
                        %>
                        <tr>
                            <td><%= patient.getId() %></td>
                            <td><%= patient.getFirstName() %> <%= patient.getLastName() %></td>
                            <td><%= patient.getEmail() %></td>
                            <td><%= patient.getWeight() != 0 ? patient.getWeight() + " kg" : "N/A" %></td>
                            <td><%= patient.getHeight() != 0 ? patient.getHeight() + " cm" : "N/A" %></td>
                            <td>
                                <div class="btn-group">
                                    <button class="btn btn-secondary" onclick="editPatient(<%= patient.getId() %>, '<%= patient.getFirstName() %>', '<%= patient.getLastName() %>', '<%= patient.getEmail() %>', '<%= patient.getWeight() %>', '<%= patient.getHeight() %>')">
                                        Edit
                                    </button>
                                    <form method="post" action="<%= request.getContextPath() %>/admin/patients" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= patient.getId() %>">
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this patient?')">
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2rem; color: #64748b;">
                                No patients found
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Edit Patient Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <button class="close" onclick="closeEditModal()">&times;</button>
            <div class="modal-header">
                <h2>Edit Patient</h2>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/admin/patients">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">

                <div class="form-group">
                    <label for="editFirstName">First Name</label>
                    <input type="text" id="editFirstName" name="firstName" required>
                </div>

                <div class="form-group">
                    <label for="editLastName">Last Name</label>
                    <input type="text" id="editLastName" name="lastName" required>
                </div>

                <div class="form-group">
                    <label for="editEmail">Email</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>

                <div class="form-group">
                    <label for="editWeight">Weight (kg)</label>
                    <input type="number" id="editWeight" name="weight" step="0.1">
                </div>

                <div class="form-group">
                    <label for="editHeight">Height (cm)</label>
                    <input type="number" id="editHeight" name="height" step="0.1">
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Update Patient</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function editPatient(id, firstName, lastName, email, weight, height) {
            document.getElementById('editId').value = id;
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editEmail').value = email;
            document.getElementById('editWeight').value = weight !== 'null' ? weight : '';
            document.getElementById('editHeight').value = height !== 'null' ? height : '';
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>
