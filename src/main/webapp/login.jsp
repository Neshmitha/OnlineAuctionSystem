<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Online Auction System</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Login</h1>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label>User Type:</label>
                    <select name="userType" required>
                        <option value="bidder">Bidder</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Username/Email:</label>
                    <input type="text" name="username" required>
                </div>

                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>

                <button type="submit" class="btn btn-primary">Login</button>
            </form>

            <div class="link-group">
                <p>Don't have an account? <a href="<%= request.getContextPath() %>/register.jsp">Register here</a></p>
                <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
            </div>
        </div>
    </div>
</body>
</html>
