<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Deposit Information</title>
    <style>
        *{
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }
        body{
            margin: 0;
            background: #f5f7fb;
            padding: 40px 24px;
        }
        .page{
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.12);
        }
        h1{
            margin-top: 0;
            color: #1f3858;
            margin-bottom: 24px;
        }
        .info-box {
            background-color: #f0f4fa;
            border: 1px solid #dbe5f4;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
        }
        .info-box p {
            margin: 8px 0;
            color: #4b5b73;
        }
        .info-box strong {
            color: #1f3858;
        }
        .form-group{
            margin-bottom: 20px;
        }
        label{
            font-weight: 600;
            color: #1f3858;
            display: block;
            margin-bottom: 6px;
        }
        input[type="number"]{
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            font-size: 15px;
        }
        .btn{
            padding: 12px 24px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            width: 100%;
        }
        .btn-primary{
            background-color: #175ea8;
            color: #fff;
        }
        .btn-secondary{
            background-color: #dbe5f4;
            color: #1f3858;
            margin-top: 12px;
        }
        .message{
            color: #c62828;
            margin-bottom: 16px;
        }
        .success-text {
            color: #2e7d32;
            font-weight: bold;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }
        String homePage = "manager".equals(user.getRole()) ? "managerHome.jsp" : "salesStaffHome.jsp";

        String contractId = request.getParameter("contractId");
        String total = request.getParameter("total");
        String client = request.getParameter("client");
        String error = (String) request.getAttribute("errorMessage");
        Boolean isSuccessFlag = (Boolean) request.getAttribute("isSuccess");
        boolean isSuccess = isSuccessFlag != null && isSuccessFlag;
        
        if (contractId == null && !isSuccess) {
            response.sendRedirect("salesStaffHome.jsp");
            return;
        }
    %>
    <div class="page">
        <h1>Car Deposit</h1>

        <% if (isSuccess) { %>
            <div class="success-text">Deposit successful! The contract has been finalized.</div>
            <button class="btn btn-secondary" onclick="window.location.href='<%= homePage %>'">Back to Home</button>
        <% } else { %>
            <div class="info-box">
                <p>Contract created successfully for <strong><%= client %></strong></p>
                <p><strong>Total Value:</strong> <%= String.format("%,.0f VND", Float.parseFloat(total)) %></p>
            </div>

            <% if (error != null) { %>
                <div class="message"><%= error %></div>
            <% } %>

            <form action="doDeposit.jsp" method="post">
                <input type="hidden" name="contractId" value="<%= contractId %>">
                <input type="hidden" name="total" value="<%= total %>">
                <input type="hidden" name="client" value="<%= client %>">

                <div class="form-group">
                    <label for="depositAmount">Deposit Amount (VND)</label>
                    <input type="number" id="depositAmount" name="depositAmount" min="0" required>
                </div>

                <button class="btn btn-primary" type="submit">Submit Deposit</button>
            </form>
            
            <form action="<%= homePage %>" method="get">
                <button class="btn btn-secondary" type="submit">Skip Deposit (Finish)</button>
            </form>
        <% } %>
    </div>
</body>
</html>
