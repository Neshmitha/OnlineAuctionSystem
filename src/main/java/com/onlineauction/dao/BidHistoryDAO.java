package com.onlineauction.dao;

import com.onlineauction.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BidHistoryDAO {

    public List<Map<String, Object>> getBidHistoryForItem(int itemId) {
        List<Map<String, Object>> bidHistory = new ArrayList<>();
        String query = "SELECT b.amount, b.bid_time, bd.name, bd.email " +
                      "FROM bids b JOIN bidder bd ON b.bidder_id = bd.id " +
                      "WHERE b.item_id = ? ORDER BY b.bid_time DESC";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> bid = new HashMap<>();
                bid.put("amount", rs.getDouble("amount"));
                bid.put("bidTime", rs.getTimestamp("bid_time"));
                bid.put("bidderName", rs.getString("name"));
                bid.put("bidderEmail", rs.getString("email"));
                bidHistory.add(bid);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return bidHistory;
    }

    public List<Map<String, Object>> getBidHistoryForBidder(int bidderId) {
        List<Map<String, Object>> bidHistory = new ArrayList<>();
        String query = "SELECT b.amount, b.bid_time, i.name as item_name, i.id as item_id, " +
                      "i.current_bid, i.highest_bidder " +
                      "FROM bids b JOIN items i ON b.item_id = i.id " +
                      "WHERE b.bidder_id = ? ORDER BY b.bid_time DESC";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, bidderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> bid = new HashMap<>();
                bid.put("amount", rs.getDouble("amount"));
                bid.put("bidTime", rs.getTimestamp("bid_time"));
                bid.put("itemName", rs.getString("item_name"));
                bid.put("itemId", rs.getInt("item_id"));
                bid.put("currentBid", rs.getDouble("current_bid"));
                bid.put("isWinning", rs.getInt("highest_bidder") == bidderId);
                bidHistory.add(bid);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return bidHistory;
    }

    public int getParticipantCount(int itemId) {
        String query = "SELECT COUNT(DISTINCT bidder_id) as count FROM bids WHERE item_id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    public int getTotalBidsCount(int itemId) {
        String query = "SELECT COUNT(*) as count FROM bids WHERE item_id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }
}
