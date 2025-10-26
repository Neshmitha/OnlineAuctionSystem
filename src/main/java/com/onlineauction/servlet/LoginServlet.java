package com.onlineauction.servlet;

import com.onlineauction.dao.AdminDAO;
import com.onlineauction.dao.BidderDAO;
import com.onlineauction.model.Admin;
import com.onlineauction.model.Bidder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();
    private BidderDAO bidderDAO = new BidderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        if ("admin".equals(userType)) {
            Admin admin = adminDAO.authenticate(username, password);
            if (admin != null) {
                session.setAttribute("admin", admin);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid admin credentials");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else if ("bidder".equals(userType)) {
            Bidder bidder = bidderDAO.authenticate(username, password);
            if (bidder != null) {
                session.setAttribute("bidder", bidder);
                response.sendRedirect(request.getContextPath() + "/bidder/dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid bidder credentials");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid user type");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
