<%@ page import="com.onlineauction.model.Bidder" %>
<%@ page import="com.onlineauction.model.Order" %>
<%@ page import="com.onlineauction.model.ShippingInfo" %>
<%@ page import="com.onlineauction.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%
    Bidder bidder = (Bidder) session.getAttribute("bidder");
    if (bidder == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByBidderId(bidder.getId());

    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .order-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }
        .order-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .detail-item {
            padding: 10px;
            background: #f9f9f9;
            border-radius: 4px;
        }
        .detail-label {
            font-weight: bold;
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
        }
        .detail-value {
            color: #333;
            font-size: 14px;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-paid { background: #d4edda; color: #155724; }
        .status-failed { background: #f8d7da; color: #721c24; }
        .status-processing { background: #d1ecf1; color: #0c5460; }
        .status-shipped { background: #cce5ff; color: #004085; }
        .status-delivered { background: #d4edda; color: #155724; }
        .address-form {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            margin-bottom: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .form-group input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .shipping-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
        }
        .tracking-info {
            background: #d4edda;
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>My Orders</h1>
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>

        <% if (message != null) { %>
            <div class="message success"><%= message %></div>
        <% } %>

        <% if (orders.isEmpty()) { %>
            <div class="message info">You haven't won any auctions yet.</div>
        <% } else { %>
            <% for (Order order : orders) {
                ShippingInfo shippingInfo = orderDAO.getShippingInfo(order.getId());
            %>
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <h3 style="margin: 0;">Order #<%= order.getId() %></h3>
                            <p style="margin: 5px 0; color: #666;">Item: <%= order.getItemName() %></p>
                        </div>
                        <div>
                            <span class="status-badge status-<%= order.getPaymentStatus().toLowerCase() %>">
                                <%= order.getPaymentStatus() %>
                            </span>
                            <span class="status-badge status-<%= order.getOrderStatus().toLowerCase().replace("_", "-") %>">
                                <%= order.getOrderStatus().replace("_", " ") %>
                            </span>
                        </div>
                    </div>

                    <div class="order-details">
                        <div class="detail-item">
                            <div class="detail-label">Final Price</div>
                            <div class="detail-value">$<%= String.format("%.2f", order.getFinalPrice()) %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Order Date</div>
                            <div class="detail-value"><%= order.getOrderDate() %></div>
                        </div>
                        <% if (order.getPaymentDate() != null) { %>
                            <div class="detail-item">
                                <div class="detail-label">Payment Date</div>
                                <div class="detail-value"><%= order.getPaymentDate() %></div>
                            </div>
                        <% } %>
                    </div>

                    <% if ("PENDING".equals(order.getPaymentStatus())) { %>
                        <div style="margin-top: 15px; padding: 15px; background: #fff3cd; border-radius: 4px;">
                            <p style="margin: 0 0 10px 0; font-weight: bold;">Payment Required</p>
                            <p style="margin: 0 0 15px 0; color: #666;">Click the button below to confirm your payment of $<%= String.format("%.2f", order.getFinalPrice()) %></p>
                            <form action="<%= request.getContextPath() %>/bidder/confirmPayment" method="post" style="display: inline;">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <button type="submit" class="btn btn-success" onclick="return confirm('Confirm payment of $<%= String.format("%.2f", order.getFinalPrice()) %>?')">Confirm Payment</button>
                            </form>
                        </div>
                    <% } %>

                    <% if ("PAID".equals(order.getPaymentStatus()) && shippingInfo == null) { %>
                        <div class="address-form">
                            <h4 style="margin-top: 0;">Provide Shipping Address</h4>
                            <form action="<%= request.getContextPath() %>/bidder/submitShippingAddress" method="post">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Recipient Name *</label>
                                        <input type="text" name="recipientName" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Phone *</label>
                                        <input type="tel" name="phone" required>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Address Line 1 *</label>
                                        <input type="text" name="addressLine1" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Address Line 2</label>
                                        <input type="text" name="addressLine2">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>City *</label>
                                        <input type="text" name="city" required>
                                    </div>
                                    <div class="form-group">
                                        <label>State *</label>
                                        <input type="text" name="state" required>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Postal Code *</label>
                                        <input type="text" name="postalCode" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Country *</label>
                                        <input type="text" name="country" value="USA" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit Address</button>
                            </form>
                        </div>
                    <% } %>

                    <% if (shippingInfo != null) { %>
                        <div class="shipping-info">
                            <h4 style="margin-top: 0;">Shipping Address</h4>
                            <p style="margin: 5px 0;"><strong><%= shippingInfo.getRecipientName() %></strong></p>
                            <p style="margin: 5px 0;"><%= shippingInfo.getAddressLine1() %></p>
                            <% if (shippingInfo.getAddressLine2() != null && !shippingInfo.getAddressLine2().isEmpty()) { %>
                                <p style="margin: 5px 0;"><%= shippingInfo.getAddressLine2() %></p>
                            <% } %>
                            <p style="margin: 5px 0;"><%= shippingInfo.getCity() %>, <%= shippingInfo.getState() %> <%= shippingInfo.getPostalCode() %></p>
                            <p style="margin: 5px 0;"><%= shippingInfo.getCountry() %></p>
                            <p style="margin: 5px 0;">Phone: <%= shippingInfo.getPhone() %></p>
                        </div>

                        <% if (shippingInfo.getTrackingNumber() != null) { %>
                            <div class="tracking-info">
                                <h4 style="margin-top: 0;">Tracking Information</h4>
                                <p style="margin: 5px 0;"><strong>Shipping Method:</strong> <%= shippingInfo.getShippingMethod() %></p>
                                <p style="margin: 5px 0;"><strong>Tracking Number:</strong> <%= shippingInfo.getTrackingNumber() %></p>
                                <p style="margin: 5px 0;"><strong>Shipped Date:</strong> <%= shippingInfo.getShippedDate() %></p>
                                <% if (shippingInfo.getEstimatedDelivery() != null) { %>
                                    <p style="margin: 5px 0;"><strong>Estimated Delivery:</strong> <%= shippingInfo.getEstimatedDelivery() %></p>
                                <% } %>
                                <% if (shippingInfo.getActualDelivery() != null) { %>
                                    <p style="margin: 5px 0; color: green;"><strong>Delivered On:</strong> <%= shippingInfo.getActualDelivery() %></p>
                                <% } %>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>
