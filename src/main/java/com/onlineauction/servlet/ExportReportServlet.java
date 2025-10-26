package com.onlineauction.servlet;

import com.onlineauction.dao.ItemDAO;
import com.onlineauction.dao.BidHistoryDAO;
import com.onlineauction.model.Admin;
import com.onlineauction.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/exportReport")
public class ExportReportServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private BidHistoryDAO bidHistoryDAO = new BidHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String reportType = request.getParameter("type");
        if (reportType == null) {
            reportType = "all";
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"auction_report_" + System.currentTimeMillis() + ".csv\"");

        PrintWriter writer = response.getWriter();

        if ("items".equals(reportType)) {
            exportItemsReport(writer);
        } else if ("bids".equals(reportType)) {
            exportBidsReport(writer);
        } else {
            exportAllReport(writer);
        }

        writer.flush();
    }

    private void exportItemsReport(PrintWriter writer) {
        writer.println("Item ID,Item Name,Description,Base Price,Current Bid,Status,Participants,Total Bids,Start Time,End Time");

        List<Item> items = itemDAO.getAllItems();
        for (Item item : items) {
            int participants = bidHistoryDAO.getParticipantCount(item.getId());
            int totalBids = bidHistoryDAO.getTotalBidsCount(item.getId());

            writer.printf("%d,\"%s\",\"%s\",%.2f,%.2f,%s,%d,%d,%s,%s%n",
                    item.getId(),
                    item.getName().replace("\"", "\"\""),
                    item.getDescription().replace("\"", "\"\""),
                    item.getBasePrice(),
                    item.getCurrentBid(),
                    item.getStatus(),
                    participants,
                    totalBids,
                    item.getBidStartTime(),
                    item.getBidEndTime()
            );
        }
    }

    private void exportBidsReport(PrintWriter writer) {
        writer.println("Item ID,Item Name,Bidder Name,Bidder Email,Bid Amount,Bid Time");

        List<Item> items = itemDAO.getAllItems();
        for (Item item : items) {
            List<Map<String, Object>> bids = bidHistoryDAO.getBidHistoryForItem(item.getId());
            for (Map<String, Object> bid : bids) {
                writer.printf("%d,\"%s\",\"%s\",\"%s\",%.2f,%s%n",
                        item.getId(),
                        item.getName().replace("\"", "\"\""),
                        bid.get("bidderName").toString().replace("\"", "\"\""),
                        bid.get("bidderEmail"),
                        (Double) bid.get("amount"),
                        bid.get("bidTime")
                );
            }
        }
    }

    private void exportAllReport(PrintWriter writer) {
        writer.println("AUCTION SYSTEM COMPLETE REPORT");
        writer.println();
        writer.println("ITEMS SUMMARY");
        writer.println("Item ID,Item Name,Description,Base Price,Current Bid,Status,Participants,Total Bids");

        List<Item> items = itemDAO.getAllItems();
        for (Item item : items) {
            int participants = bidHistoryDAO.getParticipantCount(item.getId());
            int totalBids = bidHistoryDAO.getTotalBidsCount(item.getId());

            writer.printf("%d,\"%s\",\"%s\",%.2f,%.2f,%s,%d,%d%n",
                    item.getId(),
                    item.getName().replace("\"", "\"\""),
                    item.getDescription().replace("\"", "\"\""),
                    item.getBasePrice(),
                    item.getCurrentBid(),
                    item.getStatus(),
                    participants,
                    totalBids
            );
        }

        writer.println();
        writer.println("DETAILED BIDS");
        writer.println("Item ID,Item Name,Bidder Name,Bidder Email,Bid Amount,Bid Time");

        for (Item item : items) {
            List<Map<String, Object>> bids = bidHistoryDAO.getBidHistoryForItem(item.getId());
            for (Map<String, Object> bid : bids) {
                writer.printf("%d,\"%s\",\"%s\",\"%s\",%.2f,%s%n",
                        item.getId(),
                        item.getName().replace("\"", "\"\""),
                        bid.get("bidderName").toString().replace("\"", "\"\""),
                        bid.get("bidderEmail"),
                        (Double) bid.get("amount"),
                        bid.get("bidTime")
                );
            }
        }
    }
}
