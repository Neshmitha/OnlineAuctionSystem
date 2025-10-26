Online Auction System
Project Description

A web-based Online Auction System developed using Java, JSP, Servlets, and MySQL.
This system allows users to participate in online auctions, place bids in real-time, and manage orders with secure payment and delivery tracking.
It demonstrates dynamic web development, database integration, and role-based user management.

Features

User Authentication: Separate login for Admin and Bidder.

Product Management: Admin can add, update, or remove auction items.

Real-Time Bidding: Tracks the highest bid dynamically for each product.

Order & Delivery Management: Winners can place orders, make payments, and track delivery status.

Database Integration: All data is stored in MySQL (users, admin, products, bids, orders).

Dynamic Web Pages: Built with JSP and Servlets for interactive user experience.

Technology Stack

Frontend: JSP

Backend: Java Servlets

Database: MySQL

Server: Apache Tomcat

Installation / Setup

Clone the repository:

git clone https://github.com/neshmitha/OnlineAuctionSystem.git


Open the project in Eclipse IDE.

Configure Apache Tomcat server in Eclipse.

Create a MySQL database named online_auction.

Update database credentials in the project’s JDBC connection (replace placeholders below):

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/online_auction",
    "your_db_username",   // replace with your MySQL username
    "your_db_password");  // replace with your MySQL password


Run the project on the server and access via browser.

Database Tables

users – stores bidder information.

admin – stores admin credentials.

products – stores auction items.

bids – stores bid history.

orders – stores order and payment details.
Author

Neshmitha Burgu
Email: neshmithab1@gmail.com
