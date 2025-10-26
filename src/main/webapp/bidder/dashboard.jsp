<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Bidder" %>
<%@ page import="com.onlineauction.model.Item" %>
<%@ page import="com.onlineauction.dao.ItemDAO" %>
<%@ page import="java.util.List" %>
<%
    Bidder bidder = (Bidder) session.getAttribute("bidder");
    if (bidder == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    ItemDAO itemDAO = new ItemDAO();
    List<Item> items = itemDAO.getAllItems();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bidder Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <meta http-equiv="refresh" content="30">
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Bidder Dashboard</h1>
            <div class="user-info">
                <span>Welcome, <%= bidder.getName() %></span>
                <a href="<%= request.getContextPath() %>/bidder/my_orders.jsp" class="btn btn-secondary">My Orders</a>
                <a href="<%= request.getContextPath() %>/bidder/bid_history.jsp" class="btn btn-secondary">My Bids</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <div class="items-grid">
            <% if (items.isEmpty()) { %>
                <p class="no-items">No items available for auction.</p>
            <% } else { %>
                <% for (Item item : items) {
                    String statusClass = "";
                    if ("Active".equals(item.getStatus())) {
                        statusClass = "status-active";
                    } else if ("Closed".equals(item.getStatus())) {
                        statusClass = "status-closed";
                    } else {
                        statusClass = "status-not-started";
                    }
                %>
                    <div class="item-card">
                        <% if (item.getImage() != null && !item.getImage().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= item.getImage() %>" alt="<%= item.getName() %>" class="item-image">
                        <% } else { %>
                            <div class="item-image-placeholder">No Image</div>
                        <% } %>

                        <div class="item-details">
                            <h3><%= item.getName() %></h3>
                            <p class="item-description"><%= item.getDescription() %></p>
                            <p><strong>Base Price:</strong> $<%= item.getBasePrice() %></p>
                            <p><strong>Current Bid:</strong> $<%= item.getCurrentBid() %></p>
                            <p><strong>Start Time:</strong> <%= item.getBidStartTime() %></p>
                            <p><strong>End Time:</strong> <%= item.getBidEndTime() %></p>
                            <p class="<%= statusClass %>"><strong>Status:</strong> <%= item.getStatus() %></p>

                            <% if ("Active".equals(item.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/bidder/place_bid.jsp?itemId=<%= item.getId() %>" class="btn btn-primary">Place Bid</a>
                            <% } else if ("Closed".equals(item.getStatus())) { %>
                                <% if (item.getHighestBidder() != null && item.getHighestBidder() == bidder.getId()) { %>
                                    <button class="btn btn-success" disabled>You Won!</button>
                                <% } else { %>
                                    <button class="btn btn-disabled" disabled>Auction Closed</button>
                                <% } %>
                            <% } else { %>
                                <button class="btn btn-disabled" disabled>Not Started</button>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>
