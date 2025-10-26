package com.onlineauction.dao;

import com.onlineauction.model.Order;
import com.onlineauction.model.ShippingInfo;
import com.onlineauction.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (item_id, bidder_id, final_price, payment_status, order_status) VALUES (?, ?, ?, 'PENDING', 'PAYMENT_PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, order.getItemId());
            stmt.setInt(2, order.getBidderId());
            stmt.setDouble(3, order.getFinalPrice());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, i.name as item_name, b.name as bidder_name, b.email as bidder_email " +
                     "FROM orders o " +
                     "JOIN items i ON o.item_id = i.id " +
                     "JOIN bidder b ON o.bidder_id = b.id " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByBidderId(int bidderId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, i.name as item_name, b.name as bidder_name, b.email as bidder_email " +
                     "FROM orders o " +
                     "JOIN items i ON o.item_id = i.id " +
                     "JOIN bidder b ON o.bidder_id = b.id " +
                     "WHERE o.bidder_id = ? " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bidderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, i.name as item_name, b.name as bidder_name, b.email as bidder_email " +
                     "FROM orders o " +
                     "JOIN items i ON o.item_id = i.id " +
                     "JOIN bidder b ON o.bidder_id = b.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOrderFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ?, payment_date = ?, order_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentStatus);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, paymentStatus.equals("PAID") ? "PROCESSING" : "PAYMENT_PENDING");
            stmt.setInt(4, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOrderStatus(int orderId, String orderStatus) {
        String sql = "UPDATE orders SET order_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderStatus);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveShippingInfo(ShippingInfo shippingInfo) {
        String sql = "INSERT INTO shipping_info (order_id, recipient_name, address_line1, address_line2, city, state, postal_code, country, phone) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE recipient_name=?, address_line1=?, address_line2=?, city=?, state=?, postal_code=?, country=?, phone=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shippingInfo.getOrderId());
            stmt.setString(2, shippingInfo.getRecipientName());
            stmt.setString(3, shippingInfo.getAddressLine1());
            stmt.setString(4, shippingInfo.getAddressLine2());
            stmt.setString(5, shippingInfo.getCity());
            stmt.setString(6, shippingInfo.getState());
            stmt.setString(7, shippingInfo.getPostalCode());
            stmt.setString(8, shippingInfo.getCountry());
            stmt.setString(9, shippingInfo.getPhone());
            stmt.setString(10, shippingInfo.getRecipientName());
            stmt.setString(11, shippingInfo.getAddressLine1());
            stmt.setString(12, shippingInfo.getAddressLine2());
            stmt.setString(13, shippingInfo.getCity());
            stmt.setString(14, shippingInfo.getState());
            stmt.setString(15, shippingInfo.getPostalCode());
            stmt.setString(16, shippingInfo.getCountry());
            stmt.setString(17, shippingInfo.getPhone());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ShippingInfo getShippingInfo(int orderId) {
        String sql = "SELECT * FROM shipping_info WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ShippingInfo shippingInfo = new ShippingInfo();
                shippingInfo.setId(rs.getInt("id"));
                shippingInfo.setOrderId(rs.getInt("order_id"));
                shippingInfo.setRecipientName(rs.getString("recipient_name"));
                shippingInfo.setAddressLine1(rs.getString("address_line1"));
                shippingInfo.setAddressLine2(rs.getString("address_line2"));
                shippingInfo.setCity(rs.getString("city"));
                shippingInfo.setState(rs.getString("state"));
                shippingInfo.setPostalCode(rs.getString("postal_code"));
                shippingInfo.setCountry(rs.getString("country"));
                shippingInfo.setPhone(rs.getString("phone"));
                shippingInfo.setShippingMethod(rs.getString("shipping_method"));
                shippingInfo.setTrackingNumber(rs.getString("tracking_number"));
                shippingInfo.setShippedDate(rs.getTimestamp("shipped_date"));
                shippingInfo.setEstimatedDelivery(rs.getTimestamp("estimated_delivery"));
                shippingInfo.setActualDelivery(rs.getTimestamp("actual_delivery"));
                return shippingInfo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateShippingDetails(int orderId, String shippingMethod, String trackingNumber, Timestamp estimatedDelivery) {
        String sql = "UPDATE shipping_info SET shipping_method = ?, tracking_number = ?, shipped_date = ?, estimated_delivery = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, shippingMethod);
            stmt.setString(2, trackingNumber);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(4, estimatedDelivery);
            stmt.setInt(5, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAsDelivered(int orderId) {
        String sql = "UPDATE shipping_info SET actual_delivery = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, orderId);
            if (stmt.executeUpdate() > 0) {
                updateOrderStatus(orderId, "DELIVERED");
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addStatusHistory(int orderId, String status, String notes, String updatedBy) {
        String sql = "INSERT INTO order_status_history (order_id, status, notes, updated_by) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setString(2, status);
            stmt.setString(3, notes);
            stmt.setString(4, updatedBy);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setItemId(rs.getInt("item_id"));
        order.setBidderId(rs.getInt("bidder_id"));
        order.setFinalPrice(rs.getDouble("final_price"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setPaymentDate(rs.getTimestamp("payment_date"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setItemName(rs.getString("item_name"));
        order.setBidderName(rs.getString("bidder_name"));
        order.setBidderEmail(rs.getString("bidder_email"));
        return order;
    }
}
