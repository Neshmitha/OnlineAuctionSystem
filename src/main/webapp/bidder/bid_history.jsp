<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Bidder" %>
<%@ page import="com.onlineauction.dao.BidHistoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Bidder bidder = (Bidder) session.getAttribute("bidder");
    if (bidder == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BidHistoryDAO bidHistoryDAO = new BidHistoryDAO();
    List<Map<String, Object>> bidHistory = bidHistoryDAO.getBidHistoryForBidder(bidder.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bid History</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>My Bid History</h1>
            <div class="user-info">
                <a href="<%= request.getContextPath() %>/bidder/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <div class="items-table">
            <% if (bidHistory.isEmpty()) { %>
                <p class="no-items">You haven't placed any bids yet.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Your Bid</th>
                            <th>Current Highest Bid</th>
                            <th>Status</th>
                            <th>Bid Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> bid : bidHistory) {
                            boolean isWinning = (Boolean) bid.get("isWinning");
                            String statusClass = isWinning ? "status-active" : "status-closed";
                            String statusText = isWinning ? "Winning" : "Outbid";
                        %>
                            <tr>
                                <td><%= bid.get("itemName") %></td>
                                <td>$<%= bid.get("amount") %></td>
                                <td>$<%= bid.get("currentBid") %></td>
                                <td class="<%= statusClass %>"><%= statusText %></td>
                                <td><%= bid.get("bidTime") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
