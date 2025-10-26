<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Online Auction System</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Register as Bidder</h1>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post">
                <div class="form-group">
                    <label>Full Name:</label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" required>
                </div>

                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>

                <button type="submit" class="btn btn-primary">Register</button>
            </form>

            <div class="link-group">
                <p>Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Login here</a></p>
                <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
            </div>
        </div>
    </div>
</body>
</html>
