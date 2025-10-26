package com.onlineauction.servlet;

import com.onlineauction.dao.BidDAO;
import com.onlineauction.dao.ItemDAO;
import com.onlineauction.model.Bidder;
import com.onlineauction.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/bidder/placeBid")
public class PlaceBidServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private BidDAO bidDAO = new BidDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Bidder bidder = (Bidder) session.getAttribute("bidder");

        if (bidder == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("itemId"));
        double bidAmount = Double.parseDouble(request.getParameter("bidAmount"));

        Item item = itemDAO.getItemById(itemId);

        if (item == null) {
            request.setAttribute("error", "Item not found.");
            request.getRequestDispatcher("/bidder/place_bid.jsp?itemId=" + itemId).forward(request, response);
            return;
        }

        if (!"Active".equals(item.getStatus())) {
            request.setAttribute("error", "Auction is not active.");
            request.getRequestDispatcher("/bidder/place_bid.jsp?itemId=" + itemId).forward(request, response);
            return;
        }

        double minimumIncrement = 1.0;
        double minimumBid = item.getCurrentBid() + minimumIncrement;

        if (bidAmount < minimumBid) {
            request.setAttribute("error", "Bid must be at least $" + minimumBid + " (current bid + $" + minimumIncrement + " minimum increment)");
            request.getRequestDispatcher("/bidder/place_bid.jsp?itemId=" + itemId).forward(request, response);
            return;
        }

        boolean bidPlaced = bidDAO.placeBid(bidder.getId(), itemId, bidAmount);
        if (bidPlaced) {
            itemDAO.updateCurrentBid(itemId, bidAmount, bidder.getId());
            request.setAttribute("success", "Bid placed successfully!");
        } else {
            request.setAttribute("error", "Failed to place bid.");
        }

        request.getRequestDispatcher("/bidder/place_bid.jsp?itemId=" + itemId).forward(request, response);
    }
}
