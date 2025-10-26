package com.onlineauction.servlet;

import com.onlineauction.dao.ItemDAO;
import com.onlineauction.dao.OrderDAO;
import com.onlineauction.model.Item;
import com.onlineauction.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/admin/endAuctionEarly")
public class EndAuctionEarlyServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("itemId"));

        Item item = itemDAO.getItemById(itemId);

        if (item != null && "Active".equals(item.getStatus())) {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            boolean updated = itemDAO.updateBidEndTime(itemId, now);

            if (updated && item.getHighestBidder() != null) {
                Order order = new Order(itemId, item.getHighestBidder(), item.getCurrentBid());
                orderDAO.createOrder(order);
            }

            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?message=" +
                                (updated ? "Auction ended successfully" : "Failed to end auction"));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=Invalid auction status");
        }
    }
}
