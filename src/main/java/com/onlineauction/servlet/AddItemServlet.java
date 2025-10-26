package com.onlineauction.servlet;

import com.onlineauction.dao.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/admin/addItem")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AddItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        Timestamp startTimestamp = Timestamp.valueOf(startTime.replace("T", " ") + ":00");
        Timestamp endTimestamp = Timestamp.valueOf(endTime.replace("T", " ") + ":00");

        String imagePath = null;
        Part filePart = request.getPart("image");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = getFileName(filePart);
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            filePart.write(filePath);
            imagePath = UPLOAD_DIR + "/" + uniqueFileName;
        }

        boolean success = itemDAO.addItem(name, description, basePrice, startTimestamp, endTimestamp, imagePath);

        if (success) {
            request.setAttribute("success", "Item added successfully!");
        } else {
            request.setAttribute("error", "Failed to add item.");
        }
        request.getRequestDispatcher("/admin/add_item.jsp").forward(request, response);
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
