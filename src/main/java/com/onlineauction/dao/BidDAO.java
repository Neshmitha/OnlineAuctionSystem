package com.onlineauction.dao;

import com.onlineauction.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

public class BidDAO {

    public boolean placeBid(int bidderId, int itemId, double amount) {
        String query = "INSERT INTO bids (bidder_id, item_id, amount, bid_time) VALUES (?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, bidderId);
            ps.setInt(2, itemId);
            ps.setDouble(3, amount);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }
}
