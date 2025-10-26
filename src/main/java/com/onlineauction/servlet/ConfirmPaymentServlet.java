package com.onlineauction.servlet;

import com.onlineauction.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/bidder/confirmPayment")
public class ConfirmPaymentServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("bidder") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        boolean success = orderDAO.updatePaymentStatus(orderId, "PAID");

        if (success) {
            orderDAO.addStatusHistory(orderId, "PROCESSING", "Payment confirmed by bidder", "bidder");
        }

        response.sendRedirect(request.getContextPath() + "/bidder/my_orders.jsp?message=" +
                            (success ? "Payment confirmed successfully" : "Failed to confirm payment"));
    }
}
