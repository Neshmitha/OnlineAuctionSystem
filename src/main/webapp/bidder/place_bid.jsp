<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.onlineauction.model.Bidder" %>
<%@ page import="com.onlineauction.model.Item" %>
<%@ page import="com.onlineauction.dao.ItemDAO" %>
<%@ page import="com.onlineauction.dao.BidHistoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Bidder bidder = (Bidder) session.getAttribute("bidder");
    if (bidder == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String itemIdParam = request.getParameter("itemId");
    if (itemIdParam == null) {
        response.sendRedirect(request.getContextPath() + "/bidder/dashboard.jsp");
        return;
    }

    int itemId = Integer.parseInt(itemIdParam);
    ItemDAO itemDAO = new ItemDAO();
    Item item = itemDAO.getItemById(itemId);

    if (item == null) {
        response.sendRedirect(request.getContextPath() + "/bidder/dashboard.jsp");
        return;
    }

    BidHistoryDAO bidHistoryDAO = new BidHistoryDAO();
    List<Map<String, Object>> bidHistory = bidHistoryDAO.getBidHistoryForItem(itemId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Place Bid</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        function updateCountdown() {
            var endTime = new Date('<%= item.getBidEndTime() %>').getTime();
            var now = new Date().getTime();
            var distance = endTime - now;

            if (distance < 0) {
                document.getElementById('countdown').innerHTML = 'AUCTION ENDED';
                return;
            }

            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);

            document.getElementById('countdown').innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s";
        }

        setInterval(updateCountdown, 1000);
        window.onload = updateCountdown;
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Place Bid</h1>
            <a href="<%= request.getContextPath() %>/bidder/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="notification error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="notification success"><%= request.getAttribute("success") %></div>
            <% } %>

            <% if (item.getImage() != null && !item.getImage().isEmpty()) { %>
                <img src="<%= request.getContextPath() %>/<%= item.getImage() %>" alt="<%= item.getName() %>" class="item-image" style="max-width: 400px; margin: 20px auto; display: block;">
            <% } else { %>
                <div class="item-image-placeholder" style="max-width: 400px; margin: 20px auto;">No Image Available</div>
            <% } %>

            <div class="item-info">
                <div>
                    <p><strong>Item Name:</strong></p>
                    <h2><%= item.getName() %></h2>
                </div>
                <div>
                    <p><strong>Description:</strong></p>
                    <p><%= item.getDescription() %></p>
                </div>
                <div>
                    <p><strong>Current Bid:</strong></p>
                    <h3 style="color: #667eea; margin: 5px 0;">$<%= item.getCurrentBid() %></h3>
                </div>
                <div>
                    <p><strong>Status:</strong></p>
                    <p class="status-<%= item.getStatus().toLowerCase() %>"><%= item.getStatus() %></p>
                </div>
            </div>

            <% if ("Active".equals(item.getStatus())) { %>
                <div class="countdown-timer">
                    Time Remaining: <span id="countdown"></span>
                </div>
            <% } %>

            <% if ("Active".equals(item.getStatus())) { %>
                <form action="<%= request.getContextPath() %>/bidder/placeBid" method="post">
                    <input type="hidden" name="itemId" value="<%= item.getId() %>">

                    <div class="form-group">
                        <label>Your Bid Amount ($):</label>
                        <input type="number" step="0.01" name="bidAmount"
                               min="<%= item.getCurrentBid() + 1.0 %>"
                               value="<%= item.getCurrentBid() + 1.0 %>"
                               required>
                        <small>Minimum bid: $<%= item.getCurrentBid() + 1.0 %> (includes $1.00 minimum increment)</small>
                    </div>

                    <button type="submit" class="btn btn-primary">Submit Bid</button>
                </form>
            <% } else { %>
                <p class="error-message">This auction is not currently active.</p>
            <% } %>

            <div style="margin-top: 40px;">
                <h2>Bidding Activity</h2>
                <p style="color: #666; margin-bottom: 20px;">
                    <strong><%= bidHistoryDAO.getParticipantCount(itemId) %></strong> bidders have placed
                    <strong><%= bidHistory.size() %></strong> total bids
                </p>

                <% if (bidHistory.isEmpty()) { %>
                    <p class="no-items">No bids placed yet. Be the first to bid!</p>
                <% } else { %>
                    <div class="items-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Rank</th>
                                    <th>Bidder</th>
                                    <th>Bid Amount</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                int rank = 1;
                                for (Map<String, Object> bid : bidHistory) {
                                    boolean isLeading = rank == 1 && "Active".equals(item.getStatus());
                                    boolean isMyBid = bid.get("bidderEmail").equals(bidder.getEmail());
                                    String rowStyle = "";
                                    if (isLeading) {
                                        rowStyle = "style='background-color: #d4edda;'";
                                    } else if (isMyBid) {
                                        rowStyle = "style='background-color: #fff3cd;'";
                                    }
                                %>
                                    <tr <%= rowStyle %>>
                                        <td><strong>#<%= rank %></strong></td>
                                        <td>
                                            <%= bid.get("bidderName") %>
                                            <% if (isMyBid) { %>
                                                <span style="color: #856404; font-weight: bold;">(You)</span>
                                            <% } %>
                                        </td>
                                        <td><strong>$<%= String.format("%.2f", (Double)bid.get("amount")) %></strong></td>
                                        <td><%= bid.get("bidTime") %></td>
                                        <td>
                                            <% if (isLeading) { %>
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
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
