<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Item - Admin</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Add New Auction Item</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/admin/addItem" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Item Name:</label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-group">
                    <label>Description:</label>
                    <textarea name="description" rows="4" required></textarea>
                </div>

                <div class="form-group">
                    <label>Base Price ($):</label>
                    <input type="number" step="0.01" name="basePrice" required>
                </div>

                <div class="form-group">
                    <label>Auction Start Time:</label>
                    <input type="datetime-local" name="startTime" required>
                </div>

                <div class="form-group">
                    <label>Auction End Time:</label>
                    <input type="datetime-local" name="endTime" required>
                </div>

                <div class="form-group">
                    <label>Upload Image:</label>
                    <input type="file" name="image" accept="image/*">
                    <small>Upload an image file (JPG, PNG, GIF) - Optional</small>
                </div>

                <button type="submit" class="btn btn-primary">Add Item</button>
            </form>
        </div>
    </div>
</body>
</html>
