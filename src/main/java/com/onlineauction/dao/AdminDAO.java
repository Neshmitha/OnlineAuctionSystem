package com.onlineauction.dao;

import com.onlineauction.model.Admin;
import com.onlineauction.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class AdminDAO {

    public Admin authenticate(String username, String password) {
        String query = "SELECT * FROM admin WHERE username = ? AND password = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Admin(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = DBConnection.getConnection();

        try {
            String itemsQuery = "SELECT COUNT(*) as total, " +
                              "SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active, " +
                              "SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END) as closed " +
                              "FROM items";
            PreparedStatement ps = conn.prepareStatement(itemsQuery);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalItems", rs.getInt("total"));
                stats.put("activeAuctions", rs.getInt("active"));
                stats.put("closedAuctions", rs.getInt("closed"));
            }

            String biddersQuery = "SELECT COUNT(*) as total FROM bidder";
            ps = conn.prepareStatement(biddersQuery);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalBidders", rs.getInt("total"));
            }

            String bidsQuery = "SELECT COUNT(*) as total, SUM(amount) as totalValue FROM bids";
            ps = conn.prepareStatement(bidsQuery);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalBids", rs.getInt("total"));
                stats.put("totalBidValue", rs.getDouble("totalValue"));
            }

            String revenueQuery = "SELECT SUM(current_bid) as revenue FROM items WHERE status = 'Closed'";
            ps = conn.prepareStatement(revenueQuery);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalRevenue", rs.getDouble("revenue"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }

        return stats;
    }
}
