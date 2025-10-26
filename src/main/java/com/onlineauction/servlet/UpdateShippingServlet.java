package com.onlineauction.servlet;

import com.onlineauction.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@WebServlet("/admin/updateShipping")
public class UpdateShippingServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String shippingMethod = request.getParameter("shippingMethod");
        String trackingNumber = request.getParameter("trackingNumber");
        String estimatedDeliveryStr = request.getParameter("estimatedDelivery");

        Timestamp estimatedDelivery = null;
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            estimatedDelivery = new Timestamp(dateFormat.parse(estimatedDeliveryStr).getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }

        boolean success = orderDAO.updateShippingDetails(orderId, shippingMethod, trackingNumber, estimatedDelivery);

        if (success) {
            orderDAO.updateOrderStatus(orderId, "SHIPPED");
            orderDAO.addStatusHistory(orderId, "SHIPPED",
                                     "Item shipped via " + shippingMethod + ". Tracking: " + trackingNumber, "admin");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp?message=" +
                            (success ? "Shipping details updated successfully" : "Failed to update shipping details"));
    }
}
