<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Admin" %>
<%@ page import="com.onlineauction.model.Item" %>
<%@ page import="com.onlineauction.dao.ItemDAO" %>
<%@ page import="com.onlineauction.dao.BidHistoryDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    ItemDAO itemDAO = new ItemDAO();
    BidHistoryDAO bidHistoryDAO = new BidHistoryDAO();
    List<Item> items = itemDAO.getAllItems();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <meta http-equiv="refresh" content="20">
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Admin Dashboard</h1>
            <div class="user-info">
                <span>Admin: <%= admin.getUsername() %></span>
                <a href="<%= request.getContextPath() %>/admin/orders.jsp" class="btn btn-secondary">Orders</a>
                <a href="<%= request.getContextPath() %>/admin/statistics.jsp" class="btn btn-secondary">Statistics</a>
                <a href="<%= request.getContextPath() %>/admin/add_item.jsp" class="btn btn-success">Add New Item</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <h2>All Auction Items</h2>

        <div class="items-table">
            <% if (items.isEmpty()) { %>
                <p class="no-items">No items in the system. Add some items to start auctions.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Base Price</th>
                            <th>Current Bid</th>
                            <th>Participants</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Item item : items) {
                            String statusClass = "";
                            if ("Active".equals(item.getStatus())) {
                                statusClass = "status-active";
                            } else if ("Closed".equals(item.getStatus())) {
                                statusClass = "status-closed";
                            } else {
                                statusClass = "status-not-started";
                            }
                            int participantCount = bidHistoryDAO.getParticipantCount(item.getId());
                            int totalBids = bidHistoryDAO.getTotalBidsCount(item.getId());
                        %>
                            <tr>
                                <td>
                                    <% if (item.getImage() != null && !item.getImage().isEmpty()) { %>
                                        <img src="<%= request.getContextPath() %>/<%= item.getImage() %>" alt="<%= item.getName() %>" class="admin-item-image">
                                    <% } else { %>
                                        <div class="admin-image-placeholder">No Img</div>
                                    <% } %>
                                </td>
                                <td><%= item.getId() %></td>
                                <td><%= item.getName() %></td>
                                <td><%= item.getDescription() %></td>
                                <td>$<%= item.getBasePrice() %></td>
                                <td>$<%= item.getCurrentBid() %></td>
                                <td>
                                    <% if (participantCount > 0) { %>
                                        <strong><%= participantCount %></strong> bidders<br>
                                        <small>(<%= totalBids %> total bids)</small>
                                    <% } else { %>
                                        <span style="color: #999;">No bids yet</span>
                                    <% } %>
                                </td>
                                <td><%= item.getBidStartTime() %></td>
                                <td><%= item.getBidEndTime() %></td>
                                <td class="<%= statusClass %>"><%= item.getStatus() %></td>
                                <td>
                                    <% if (totalBids > 0) { %>
                                        <a href="<%= request.getContextPath() %>/admin/item_bids.jsp?itemId=<%= item.getId() %>" class="btn btn-secondary btn-small">View Bids</a>
                                    <% } %>
                                    <% if ("Active".equals(item.getStatus())) { %>
                                        <form action="<%= request.getContextPath() %>/admin/endAuctionEarly" method="post" style="display: inline;">
                                            <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                            <button type="submit" class="btn btn-success btn-small" onclick="return confirm('End this auction now and declare winner?')">End Now</button>
                                        </form>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/admin/deleteItem?itemId=<%= item.getId() %>" class="btn btn-logout btn-small" onclick="return confirm('Delete this item?')">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
