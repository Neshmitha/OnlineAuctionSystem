<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Admin" %>
<%@ page import="com.onlineauction.model.Item" %>
<%@ page import="com.onlineauction.dao.ItemDAO" %>
<%@ page import="com.onlineauction.dao.BidHistoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String itemIdParam = request.getParameter("itemId");
    if (itemIdParam == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }

    int itemId = Integer.parseInt(itemIdParam);
    ItemDAO itemDAO = new ItemDAO();
    Item item = itemDAO.getItemById(itemId);

    if (item == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }

    BidHistoryDAO bidHistoryDAO = new BidHistoryDAO();
    List<Map<String, Object>> bidHistory = bidHistoryDAO.getBidHistoryForItem(itemId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bid History - <%= item.getName() %></title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <meta http-equiv="refresh" content="10">
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Bid History: <%= item.getName() %></h1>
            <div class="user-info">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <div class="item-info">
            <p><strong>Current Bid:</strong> $<%= item.getCurrentBid() %></p>
            <p><strong>Base Price:</strong> $<%= item.getBasePrice() %></p>
            <p><strong>Status:</strong> <span class="status-<%= item.getStatus().toLowerCase().replace(" ", "-") %>"><%= item.getStatus() %></span></p>
            <p><strong>Total Participants:</strong> <%= bidHistoryDAO.getParticipantCount(itemId) %> bidders</p>
            <p><strong>Total Bids:</strong> <%= bidHistory.size() %> bids</p>
        </div>

        <h2>All Bids (Latest First)</h2>
        <div class="items-table">
            <% if (bidHistory.isEmpty()) { %>
                <p class="no-items">No bids placed yet.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Bidder Name</th>
                            <th>Email</th>
                            <th>Bid Amount</th>
                            <th>Bid Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        int rank = 1;
                        for (Map<String, Object> bid : bidHistory) {
                            boolean isHighest = rank == 1 && "Active".equals(item.getStatus());
                            String rowClass = isHighest ? "style='background-color: #d4edda;'" : "";
                        %>
                            <tr <%= rowClass %>>
                                <td><strong>#<%= rank %></strong></td>
                                <td><%= bid.get("bidderName") %></td>
                                <td><%= bid.get("bidderEmail") %></td>
                                <td><strong>$<%= bid.get("amount") %></strong></td>
                                <td><%= bid.get("bidTime") %></td>
                                <td>
                                    <% if (isHighest) { %>
                                        <span class="status-active">Leading</span>
                                    <% } else if ("Closed".equals(item.getStatus()) && rank == 1) { %>
                                        <span class="status-active">Winner</span>
                                    <% } else { %>
                                        <span style="color: #999;">Outbid</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                            rank++;
                        }
                        %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
