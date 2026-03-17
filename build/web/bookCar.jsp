<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Book Car</title>
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
            max-width: 600px;
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
        .form-group{
            margin-bottom: 20px;
        }
        label{
            font-weight: 600;
            color: #1f3858;
            display: block;
            margin-bottom: 6px;
        }
        input[type="text"],
        input[type="date"],
        input[type="number"]{
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            font-size: 15px;
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
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }

        String carIdStr = request.getParameter("carId");
        String carName = request.getParameter("carName");
        String rentalPriceStr = request.getParameter("rentalPrice");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        if (carIdStr == null || startDateStr == null || endDateStr == null) {
            response.sendRedirect("searchFreeCar.jsp");
            return;
        }
        
        long days = 1;
        float contractValue = 0;
        try {
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
            long diff = endDate.getTime() - startDate.getTime();
            days = diff / (1000 * 60 * 60 * 24) + 1; 
            float price = Float.parseFloat(rentalPriceStr);
            contractValue = price * days;
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        String error = (String) request.getAttribute("errorMessage");
    %>
    <div class="page">
        <h1>Book Car</h1>
        
        <div class="info-box">
            <p><strong>Car:</strong> <%= carName %></p>
            <p><strong>Duration:</strong> <%= startDateStr %> to <%= endDateStr %> (<%= days %> days)</p>
            <p><strong>Total Value:</strong> <%= String.format("%,.0f VND", contractValue) %></p>
        </div>

        <% if(error != null) { %>
            <div class="message"><%= error %></div>
        <% } %>

        <form action="doBookCar.jsp" method="post">
            <input type="hidden" name="carId" value="<%= carIdStr %>">
            <input type="hidden" name="carName" value="<%= carName %>">
            <input type="hidden" name="rentalPrice" value="<%= rentalPriceStr %>">
            <input type="hidden" name="startDate" value="<%= startDateStr %>">
            <input type="hidden" name="endDate" value="<%= endDateStr %>">
            <input type="hidden" name="contractValue" value="<%= contractValue %>">

            <div class="form-group">
                <label for="clientName">Client Name</label>
                <input type="text" id="clientName" name="clientName" required>
            </div>
            
            <div class="form-group">
                <label for="clientPhone">Client Phone Number</label>
                <input type="text" id="clientPhone" name="clientPhone" required>
            </div>

            <button class="btn btn-primary" type="submit">Confirm Booking</button>
        </form>
        
        <form action="doSearchFreeCar.jsp" method="post">
            <input type="hidden" name="startDate" value="<%= startDateStr %>">
            <input type="hidden" name="endDate" value="<%= endDateStr %>">
            <button class="btn btn-secondary" type="submit">Back to Results</button>
        </form>
    </div>
</body>
</html>
