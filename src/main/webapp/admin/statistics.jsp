<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Admin" %>
<%@ page import="com.onlineauction.dao.AdminDAO" %>
<%@ page import="java.util.Map" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    AdminDAO adminDAO = new AdminDAO();
    Map<String, Object> stats = adminDAO.getDashboardStats();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Auction Statistics</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Auction Statistics</h1>
            <div class="user-info">
                <a href="<%= request.getContextPath() %>/admin/exportReport?type=all" class="btn btn-success">Export Full Report</a>
                <a href="<%= request.getContextPath() %>/admin/exportReport?type=items" class="btn btn-secondary">Export Items</a>
                <a href="<%= request.getContextPath() %>/admin/exportReport?type=bids" class="btn btn-secondary">Export Bids</a>
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <h2>Overview Statistics</h2>
        <div class="stats-grid">
            <div class="stats-card">
                <h3><%= stats.get("totalItems") != null ? stats.get("totalItems") : 0 %></h3>
                <p>Total Items</p>
            </div>

            <div class="stats-card">
                <h3><%= stats.get("activeAuctions") != null ? stats.get("activeAuctions") : 0 %></h3>
                <p>Active Auctions</p>
            </div>

            <div class="stats-card">
                <h3><%= stats.get("closedAuctions") != null ? stats.get("closedAuctions") : 0 %></h3>
                <p>Closed Auctions</p>
            </div>

            <div class="stats-card">
                <h3><%= stats.get("totalBidders") != null ? stats.get("totalBidders") : 0 %></h3>
                <p>Total Bidders</p>
            </div>

            <div class="stats-card">
                <h3><%= stats.get("totalBids") != null ? stats.get("totalBids") : 0 %></h3>
                <p>Total Bids Placed</p>
            </div>

            <div class="stats-card">
                <h3>$<%= String.format("%.2f", stats.get("totalRevenue") != null ? (Double)stats.get("totalRevenue") : 0.0) %></h3>
                <p>Total Revenue (Closed)</p>
            </div>

            <div class="stats-card">
                <h3>$<%= String.format("%.2f", stats.get("totalBidValue") != null ? (Double)stats.get("totalBidValue") : 0.0) %></h3>
                <p>Total Bid Value</p>
            </div>

            <div class="stats-card">
                <%
                    int totalBids = stats.get("totalBids") != null ? (Integer)stats.get("totalBids") : 0;
                    int totalItems = stats.get("totalItems") != null ? (Integer)stats.get("totalItems") : 1;
                    double avgBids = totalItems > 0 ? (double)totalBids / totalItems : 0;
                %>
                <h3><%= String.format("%.1f", avgBids) %></h3>
                <p>Avg Bids per Item</p>
            </div>
        </div>

        <div style="margin-top: 30px; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px;">
            <h2 style="margin: 0 0 15px 0;">Platform Performance</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                <div>
                    <p style="margin: 0; opacity: 0.9;">Success Rate</p>
                    <h3 style="margin: 5px 0 0 0; font-size: 1.8em;">
                        <%
                            int closedAuctions = stats.get("closedAuctions") != null ? (Integer)stats.get("closedAuctions") : 0;
                            int totalItemsCount = stats.get("totalItems") != null ? (Integer)stats.get("totalItems") : 1;
                            double successRate = totalItemsCount > 0 ? (double)closedAuctions / totalItemsCount * 100 : 0;
                        %>
                        <%= String.format("%.1f%%", successRate) %>
                    </h3>
                </div>
                <div>
                    <p style="margin: 0; opacity: 0.9;">Active Rate</p>
                    <h3 style="margin: 5px 0 0 0; font-size: 1.8em;">
                        <%
                            int activeAuctions = stats.get("activeAuctions") != null ? (Integer)stats.get("activeAuctions") : 0;
                            double activeRate = totalItemsCount > 0 ? (double)activeAuctions / totalItemsCount * 100 : 0;
                        %>
                        <%= String.format("%.1f%%", activeRate) %>
                    </h3>
                </div>
                <div>
                    <p style="margin: 0; opacity: 0.9;">Engagement</p>
                    <h3 style="margin: 5px 0 0 0; font-size: 1.8em;">
                        <%
                            int totalBiddersCount = stats.get("totalBidders") != null ? (Integer)stats.get("totalBidders") : 1;
                            double engagement = totalBiddersCount > 0 ? (double)totalBids / totalBiddersCount : 0;
                        %>
                        <%= String.format("%.1f", engagement) %> bids/user
                    </h3>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
