package com.onlineauction.dao;

import com.onlineauction.model.Item;
import com.onlineauction.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean addItem(String name, String description, double basePrice,
                           Timestamp startTime, Timestamp endTime, String image) {
        String query = "INSERT INTO items (name, description, base_price, current_bid, " +
                      "bid_start_time, bid_end_time, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, basePrice);
            ps.setDouble(4, basePrice);
            ps.setTimestamp(5, startTime);
            ps.setTimestamp(6, endTime);
            ps.setString(7, image);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM items ORDER BY id DESC";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return items;
    }

    public Item getItemById(int id) {
        String query = "SELECT * FROM items WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public boolean updateCurrentBid(int itemId, double amount, int bidderId) {
        String query = "UPDATE items SET current_bid = ?, highest_bidder = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setDouble(1, amount);
            ps.setInt(2, bidderId);
            ps.setInt(3, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean deleteItem(int itemId) {
        String query = "DELETE FROM items WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean updateBidEndTime(int itemId, Timestamp newEndTime) {
        String query = "UPDATE items SET bid_end_time = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setTimestamp(1, newEndTime);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    private Item mapResultSetToItem(ResultSet rs) throws SQLException {
        return new Item(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getDouble("base_price"),
                rs.getDouble("current_bid"),
                (Integer) rs.getObject("highest_bidder"),
                rs.getTimestamp("bid_start_time"),
                rs.getTimestamp("bid_end_time"),
                rs.getString("image")
        );
    }
}
