<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Online Auction System - Bid, Win, Celebrate</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .landing-page {
            min-height: 100vh;
            background: linear-gradient(135deg, #87ceeb 0%, #4a90e2 100%);
            display: flex;
            flex-direction: column;
        }

        .landing-nav {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px 50px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }

        .landing-nav-buttons {
            display: flex;
            gap: 15px;
        }

        .landing-nav-buttons a {
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .nav-login {
            background: white;
            color: #4a90e2;
        }

        .nav-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,255,255,0.3);
            background: #f0f8ff;
        }

        .nav-register {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .nav-register:hover {
            background: white;
            color: #4a90e2;
        }

        .landing-hero {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 50px;
            text-align: center;
        }

        .hero-content {
            max-width: 800px;
            color: white;
            animation: fadeInUp 1s ease-out;
        }

        .hero-title {
            font-size: 5em;
            font-weight: bold;
            margin: 0 0 30px 0;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.2);
            line-height: 1.2;
        }

        .hero-title::before {
            content: "🔨 ";
            font-size: 0.9em;
        }

        .hero-subtitle {
            font-size: 1.5em;
            margin: 0 0 40px 0;
            opacity: 0.95;
            font-weight: 300;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .hero-btn {
            padding: 18px 45px;
            font-size: 1.2em;
            font-weight: 600;
            border-radius: 50px;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .hero-btn-primary {
            background: white;
            color: #4a90e2;
        }

        .hero-btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255,255,255,0.4);
            background: #f0f8ff;
        }

        .hero-btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
            backdrop-filter: blur(10px);
        }

        .hero-btn-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-3px);
        }

        .landing-features {
            background: white;
            padding: 80px 50px;
        }

        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .features-title {
            text-align: center;
            font-size: 2.5em;
            color: #333;
            margin-bottom: 50px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }

        .feature-card {
            text-align: center;
            padding: 30px;
            border-radius: 15px;
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(245, 87, 108, 0.3);
            background: linear-gradient(135deg, #fff0f3 0%, #ffe8cc 100%);
        }

        .feature-icon {
            font-size: 3em;
            margin-bottom: 20px;
        }

        .feature-title {
            font-size: 1.5em;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .feature-description {
            color: #666;
            line-height: 1.6;
        }

        .landing-footer {
            background: linear-gradient(135deg, #434343 0%, #000000 100%);
            color: white;
            text-align: center;
            padding: 30px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5em;
            }
            .hero-subtitle {
                font-size: 1.2em;
            }
            .landing-nav {
                padding: 15px 20px;
            }
            .landing-features {
                padding: 50px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="landing-page">
        <nav class="landing-nav"></nav>

        <section class="landing-hero">
            <div class="hero-content">
                <h1 class="hero-title">AuctionHub</h1>
                <p class="hero-subtitle">The most exciting way to buy and sell premium items through live auctions</p>
                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/register.jsp" class="hero-btn hero-btn-primary">Get Started</a>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="hero-btn hero-btn-secondary">Sign In</a>
                </div>
            </div>
        </section>
    </div>

    <section class="landing-features">
        <div class="features-container">
            <h2 class="features-title">Why Choose AuctionHub?</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <h3 class="feature-title">Real-Time Bidding</h3>
                    <p class="feature-description">Experience the thrill of live auctions with instant bid updates and countdown timers</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3 class="feature-title">Secure Transactions</h3>
                    <p class="feature-description">Your data and transactions are protected with enterprise-level security</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">📊</div>
                    <h3 class="feature-title">Smart Analytics</h3>
                    <p class="feature-description">Track your bidding history and get insights into auction trends</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">💎</div>
                    <h3 class="feature-title">Premium Items</h3>
                    <p class="feature-description">Discover unique and valuable items from verified sellers</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🎯</div>
                    <h3 class="feature-title">Easy to Use</h3>
                    <p class="feature-description">Intuitive interface designed for both beginners and experts</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🏆</div>
                    <h3 class="feature-title">Win Big</h3>
                    <p class="feature-description">Competitive bidding system ensures the best deals for everyone</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="landing-footer">
        <p>&copy; 2024 AuctionHub. All rights reserved. Built with passion for the auction community.</p>
    </footer>
</body>
</html>
