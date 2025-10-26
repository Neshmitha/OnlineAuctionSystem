<%@ page import="com.onlineauction.model.Admin" %>
<%@ page import="com.onlineauction.model.Order" %>
<%@ page import="com.onlineauction.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getAllOrders();

    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Management - Admin</title>
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
        .action-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
        }
        .action-form {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .form-group {
            flex: 1;
            min-width: 150px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Order Management</h1>
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>

        <% if (message != null) { %>
            <div class="message success"><%= message %></div>
        <% } %>

        <div class="stats-container" style="margin-bottom: 20px;">
            <div class="stat-card">
                <h3><%= orders.stream().filter(o -> "PENDING".equals(o.getPaymentStatus())).count() %></h3>
                <p>Pending Payments</p>
            </div>
            <div class="stat-card">
                <h3><%= orders.stream().filter(o -> "PROCESSING".equals(o.getOrderStatus())).count() %></h3>
                <p>Processing</p>
            </div>
            <div class="stat-card">
                <h3><%= orders.stream().filter(o -> "SHIPPED".equals(o.getOrderStatus())).count() %></h3>
                <p>Shipped</p>
            </div>
            <div class="stat-card">
                <h3><%= orders.stream().filter(o -> "DELIVERED".equals(o.getOrderStatus())).count() %></h3>
                <p>Delivered</p>
            </div>
        </div>

        <% if (orders.isEmpty()) { %>
            <div class="message info">No orders found.</div>
        <% } else { %>
            <% for (Order order : orders) { %>
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
                            <div class="detail-label">Buyer</div>
                            <div class="detail-value"><%= order.getBidderName() %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Email</div>
                            <div class="detail-value"><%= order.getBidderEmail() %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Final Price</div>
                            <div class="detail-value">$<%= String.format("%.2f", order.getFinalPrice()) %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Order Date</div>
                            <div class="detail-value"><%= order.getOrderDate() %></div>
                        </div>
                    </div>

                    <% if ("PENDING".equals(order.getPaymentStatus())) { %>
                        <div class="action-section">
                            <h4 style="margin-top: 0;">Update Payment Status</h4>
                            <form action="<%= request.getContextPath() %>/admin/updatePayment" method="post" class="action-form">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <div class="form-group">
                                    <label>Payment Status:</label>
                                    <select name="paymentStatus" required>
                                        <option value="PAID">Paid</option>
                                        <option value="FAILED">Failed</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Update Payment</button>
                            </form>
                        </div>
                    <% } %>

                    <% if ("PROCESSING".equals(order.getOrderStatus())) { %>
                        <div class="action-section">
                            <h4 style="margin-top: 0;">Ship Order</h4>
                            <form action="<%= request.getContextPath() %>/admin/updateShipping" method="post" class="action-form">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <div class="form-group">
                                    <label>Shipping Method:</label>
                                    <select name="shippingMethod" required>
                                        <option value="Standard">Standard</option>
                                        <option value="Express">Express</option>
                                        <option value="Overnight">Overnight</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Tracking Number:</label>
                                    <input type="text" name="trackingNumber" required>
                                </div>
                                <div class="form-group">
                                    <label>Estimated Delivery:</label>
                                    <input type="date" name="estimatedDelivery" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Ship Order</button>
                            </form>
                        </div>
                    <% } %>

                    <% if ("SHIPPED".equals(order.getOrderStatus())) { %>
                        <div class="action-section">
                            <form action="<%= request.getContextPath() %>/admin/markDelivered" method="post">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <button type="submit" class="btn btn-success">Mark as Delivered</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>
