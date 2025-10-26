package com.onlineauction.servlet;

import com.onlineauction.dao.OrderDAO;
import com.onlineauction.model.Bidder;
import com.onlineauction.model.ShippingInfo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/bidder/submitShippingAddress")
public class SubmitShippingAddressServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Bidder bidder = (Bidder) session.getAttribute("bidder");
        if (bidder == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        ShippingInfo shippingInfo = new ShippingInfo();
        shippingInfo.setOrderId(orderId);
        shippingInfo.setRecipientName(request.getParameter("recipientName"));
        shippingInfo.setAddressLine1(request.getParameter("addressLine1"));
        shippingInfo.setAddressLine2(request.getParameter("addressLine2"));
        shippingInfo.setCity(request.getParameter("city"));
        shippingInfo.setState(request.getParameter("state"));
        shippingInfo.setPostalCode(request.getParameter("postalCode"));
        shippingInfo.setCountry(request.getParameter("country"));
        shippingInfo.setPhone(request.getParameter("phone"));

        boolean success = orderDAO.saveShippingInfo(shippingInfo);

        if (success) {
            orderDAO.addStatusHistory(orderId, "ADDRESS_SUBMITTED",
                                     "Shipping address submitted by bidder", "bidder");
        }

        response.sendRedirect(request.getContextPath() + "/bidder/my_orders.jsp?message=" +
                            (success ? "Shipping address submitted successfully" : "Failed to submit shipping address"));
    }
}
