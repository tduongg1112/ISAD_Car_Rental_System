<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sale Staff Home</title>
    <style>
        *{
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }
        body{
            margin: 0;
            height: 100vh;
            background: #f5f7fb;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card{
            width: 380px;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.18);
            text-align: center;
        }
        h2{
            margin-top: 0;
            color: #1f3858;
        }
        .action-btn{
            width: 100%;
            padding: 12px;
            margin-top: 16px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        .action-btn.primary{
            background-color: #175ea8;
            color: #fff;
        }
        .action-btn.primary:hover{
            background-color: #0f4d8c;
        }
        .action-btn.back{
            background-color: #dbe5f4;
            color: #1f3858;
        }
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || !"salestaff".equals(user.getRole())) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }
    %>
    <div class="card">
        <h2>Sale Staff Home</h2>
        <p>Welcome, <strong><%= user.getFullName() %></strong></p>
        <form action="searchFreeCar.jsp" method="get">
            <button class="action-btn primary" type="submit">Search & Book Car</button>
        </form>
        <form action="manageOrders.jsp" method="get">
            <button class="action-btn primary" type="submit">Manage Orders</button>
        </form>
        <form action="login.jsp" method="get">
            <button class="action-btn back" type="submit">Back</button>
        </form>
    </div>
</body>
</html>