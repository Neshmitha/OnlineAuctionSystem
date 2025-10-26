package com.onlineauction.servlet;

import com.onlineauction.dao.ItemDAO;
import com.onlineauction.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/deleteItem")
public class DeleteItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String itemIdParam = request.getParameter("itemId");
        if (itemIdParam != null) {
            int itemId = Integer.parseInt(itemIdParam);
            itemDAO.deleteItem(itemId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}
