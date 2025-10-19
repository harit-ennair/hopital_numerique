<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hopital_numerique.model.Person" %>
<%@ page import="com.example.hopital_numerique.model.Patient" %>
<%@ page import="com.example.hopital_numerique.model.Doctor" %>
<%@ page import="com.example.hopital_numerique.model.Room" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%
    Person user = (Person) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Patient patient = (Patient) user;

    // These would typically be passed from the controller
    List<Doctor> availableDoctors = (List<Doctor>) request.getAttribute("availableDoctors");
    List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Consultation - Hopital Numerique</title>
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

        .booking-form {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.25rem;
            color: #1e293b;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
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

        .form-group input,
        .form-group select {
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .time-slot {
            padding: 0.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }

        .time-slot:hover {
            border-color: #06b6d4;
            background: #f0f9ff;
        }

        .time-slot.selected {
            border-color: #06b6d4;
            background: #06b6d4;
            color: white;
        }

        .time-slot input[type="radio"] {
            display: none;
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
            margin-top: 2rem;
        }

        .patient-info {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .patient-info h3 {
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .patient-info p {
            color: #64748b;
            margin-bottom: 0.25rem;
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

        .required {
            color: #dc2626;
        }

        .note {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 1rem;
            margin-bottom: 2rem;
            border-radius: 0 8px 8px 0;
        }

        .note p {
            color: #92400e;
            margin-bottom: 0.5rem;
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
            <h1 class="page-title">Book New Consultation</h1>
            <p class="page-subtitle">Schedule your medical appointment</p>
        </div>

        <div class="note">
            <p><strong>📋 Booking Information:</strong></p>
            <p>• Consultations must be booked at least 24 hours in advance</p>
            <p>• You will receive a confirmation once your booking is approved</p>
            <p>• You can cancel pending consultations up to 2 hours before the appointment</p>
        </div>

        <div class="patient-info">
            <h3>Patient Information</h3>
            <p><strong>Name:</strong> <%= patient.getFirstName() %> <%= patient.getLastName() %></p>
            <p><strong>Email:</strong> <%= patient.getEmail() %></p>
            <p><strong>Patient ID:</strong> <%= patient.getId() %></p>
        </div>

        <form class="booking-form" action="<%= request.getContextPath() %>/patient" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="book-consultation">

            <div class="form-section">
                <h2 class="section-title">Select Doctor</h2>
                <div class="form-group">
                    <label for="doctorId">Doctor <span class="required">*</span></label>
                    <select id="doctorId" name="doctorId" required>
                        <option value="">Select a doctor...</option>
                        <% if (availableDoctors != null) {
                            for (Doctor doctor : availableDoctors) { %>
                        <option value="<%= doctor.getId() %>">
                            Dr. <%= doctor.getFirstName() %> <%= doctor.getLastName() %>
                            - <%= doctor.getSpecialty() != null ? doctor.getSpecialty() : "General" %>
                        </option>
                        <% }
                        } else { %>
                        <!-- Sample doctors for demonstration -->
                        <option value="1">Dr. John Smith - Cardiology</option>
                        <option value="2">Dr. Sarah Johnson - General Medicine</option>
                        <option value="3">Dr. Michael Brown - Orthopedics</option>
                        <option value="4">Dr. Emily Davis - Dermatology</option>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="form-section">
                <h2 class="section-title">Select Room</h2>
                <div class="form-group">
                    <label for="roomId">Room <span class="required">*</span></label>
                    <select id="roomId" name="roomId" required>
                        <option value="">Select a room...</option>
                        <% if (availableRooms != null) {
                            for (Room room : availableRooms) { %>
                        <option value="<%= room.getId() %>">
                            Room <%= room.getId() %> - <%= room.getName() %>
                        </option>
                        <% }
                        } else { %>
                        <!-- Sample rooms for demonstration -->
                        <option value="1">Room 101 - Consultation</option>
                        <option value="2">Room 102 - Examination</option>
                        <option value="3">Room 201 - Consultation</option>
                        <option value="4">Room 202 - Specialist</option>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="form-section">
                <h2 class="section-title">Date & Time</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="consultationDate">Date <span class="required">*</span></label>
                        <input type="date" id="consultationDate" name="consultationDate"
                               min="<%= LocalDate.now().plusDays(1) %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Time <span class="required">*</span></label>
                    <div class="time-slots">
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="09:00" required>
                            <span>09:00</span>
                        </label>
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="10:00" required>
                            <span>10:00</span>
                        </label>
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="11:00" required>
                            <span>11:00</span>
                        </label>
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="14:00" required>
                            <span>14:00</span>
                        </label>
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="15:00" required>
                            <span>15:00</span>
                        </label>
                        <label class="time-slot">
                            <input type="radio" name="consultationTime" value="16:00" required>
                            <span>16:00</span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">📅 Book Consultation</button>
                <form action="<%= request.getContextPath() %>/patient" method="get" style="margin: 0;">
                    <input type="hidden" name="action" value="consultations">
                    <button type="submit" class="btn btn-secondary">Cancel</button>
                </form>
            </div>
        </form>
    </main>

    <script>
        // Handle time slot selection
        document.querySelectorAll('.time-slot').forEach(slot => {
            slot.addEventListener('click', function() {
                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        // Form validation
        function validateForm() {
            const doctorId = document.getElementById('doctorId').value;
            const roomId = document.getElementById('roomId').value;
            const date = document.getElementById('consultationDate').value;
            const time = document.querySelector('input[name="consultationTime"]:checked');

            if (!doctorId || !roomId || !date || !time) {
                alert('Please fill in all required fields.');
                return false;
            }

            const selectedDate = new Date(date);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (selectedDate <= today) {
                alert('Please select a date that is at least tomorrow.');
                return false;
            }

            return confirm('Are you sure you want to book this consultation?');
        }

        // Set minimum date to tomorrow
        document.addEventListener('DOMContentLoaded', function() {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const minDate = tomorrow.toISOString().split('T')[0];
            document.getElementById('consultationDate').setAttribute('min', minDate);
        });
    </script>
</body>
</html>
