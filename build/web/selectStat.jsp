<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Statistics</title>
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
            width: 360px;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.15);
            text-align: center;
        }
        h2{
            margin-top: 0;
            color: #1f3858;
        }
        .btn{
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 14px;
        }
        .btn.primary{
            background-color: #175ea8;
            color: #fff;
        }
        .btn.back{
            background-color: #dbe5f4;
            color: #1f3858;
        }
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || !"manager".equals(user.getRole())) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }
    %>
    <div class="card">
        <h2>Statistics</h2>
        <p>Xin chào, <strong><%= user.getFullName() %></strong></p>
        <form action="carStat.jsp" method="get">
            <button class="btn primary" type="submit">Car Stat</button>
        </form>
        <form action="managerHome.jsp" method="get">
            <button class="btn back" type="submit">Back</button>
        </form>
    </div>
</body>
</html>

