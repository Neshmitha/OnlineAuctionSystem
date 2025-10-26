package com.onlineauction.dao;

import com.onlineauction.model.Bidder;
import com.onlineauction.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BidderDAO {

    public boolean register(String name, String email, String password) {
        String query = "INSERT INTO bidder (name, email, password) VALUES (?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public Bidder authenticate(String email, String password) {
        String query = "SELECT * FROM bidder WHERE email = ? AND password = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Bidder(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
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

    public Bidder getBidderById(int id) {
        String query = "SELECT * FROM bidder WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Bidder(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
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
}
