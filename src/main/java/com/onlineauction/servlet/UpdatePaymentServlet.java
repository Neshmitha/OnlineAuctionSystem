package com.onlineauction.servlet;

import com.onlineauction.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/updatePayment")
public class UpdatePaymentServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String paymentStatus = request.getParameter("paymentStatus");

        boolean success = orderDAO.updatePaymentStatus(orderId, paymentStatus);

        if (success) {
            orderDAO.addStatusHistory(orderId, paymentStatus.equals("PAID") ? "PROCESSING" : "PAYMENT_FAILED",
                                     "Payment status updated to: " + paymentStatus, "admin");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp?message=" +
                            (success ? "Payment status updated successfully" : "Failed to update payment status"));
    }
}
