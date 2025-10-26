package com.onlineauction.servlet;

import com.onlineauction.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/markDelivered")
public class MarkDeliveredServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        boolean success = orderDAO.markAsDelivered(orderId);

        if (success) {
            orderDAO.addStatusHistory(orderId, "DELIVERED",
                                     "Order delivered successfully", "admin");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp?message=" +
                            (success ? "Order marked as delivered" : "Failed to update delivery status"));
    }
}
