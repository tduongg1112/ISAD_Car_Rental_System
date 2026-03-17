<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, model.CarStat"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Car Statistics</title>
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
            max-width: 960px;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.12);
        }
        h1{
            margin-top: 0;
            color: #1f3858;
        }
        .form-row{
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        label{
            font-weight: 600;
            color: #1f3858;
            display: block;
            margin-bottom: 6px;
        }
        input[type="date"]{
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            font-size: 15px;
            width: 220px;
        }
        .btn{
            padding: 11px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
        }
        .btn-primary{
            background-color: #175ea8;
            color: #fff;
        }
        .btn-secondary{
            background-color: #dbe5f4;
            color: #1f3858;
        }
        table{
            width: 100%;
            border-collapse: collapse;
            margin-top: 24px;
        }
        th, td{
            padding: 12px 10px;
            border: 1px solid #dbe5f4;
            text-align: left;
        }
        thead{
            background-color: #1f3858;
            color: #fff;
        }
        tbody tr:nth-child(even){
            background-color: #f5f7fb;
        }
        .message{
            margin-top: 16px;
            color: #c62828;
        }
        .table-actions form{
            margin: 0;
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
        ArrayList<CarStat> carStats = (ArrayList<CarStat>) request.getAttribute("carStats");
        if(carStats == null){
            carStats = new ArrayList<>();
        }
        String startDate = (String) request.getAttribute("startDate");
        String endDate = (String) request.getAttribute("endDate");
        Boolean searchedFlag = (Boolean) request.getAttribute("searched");
        boolean searched = searchedFlag != null && searchedFlag;
        String error = (String) request.getAttribute("errorMessage");
        if(startDate == null) startDate = "";
        if(endDate == null) endDate = "";
    %>
    <div class="page">
        <h1>Car Statistics</h1>
        <form action="doCarStat.jsp" method="post">
            <div class="form-row">
                <div>
                    <label for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate" value="<%= startDate %>" required>
                </div>
                <div>
                    <label for="endDate">End Date</label>
                    <input type="date" id="endDate" name="endDate" value="<%= endDate %>" required>
                </div>
                <div style="display:flex; align-items:flex-end;">
                    <button class="btn btn-primary" type="submit">Stat</button>
                </div>
            </div>
        </form>
        <% if(error != null) { %>
            <div class="message"><%= error %></div>
        <% } else if(!searched) { %>
            <!--<div class="message" style="color:#1f3858;">Enter Time</div>-->
        <% } else if(carStats.isEmpty()) { %>
            <div class="message">No Revenue in this period</div>
        <% } %>
        <% if(searched && !carStats.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>No</th>
<!--                        <th>ID</th>-->
                        <th>Car Name</th>
                        <th>Type</th>
                        <th>Model Year</th>
                        <th>Rental Price</th>
                        <th>Total Revenue</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int no = 1;
                        for(CarStat item : carStats) {
                    %>
                    <tr>
                        <td><%= no++ %></td>
<!--                        <td><%= item.getId() %></td>-->
                        <td><%= item.getCarName() %></td>
                        <td><%= item.getCarType() %></td>
                        <td><%= item.getModelYear() %></td>
                        <td><%= String.format("%,.0f VND", item.getRentalPrice()) %></td>
                        <td><%= String.format("%,.0f VND", item.getTotalRevenue()) %></td>
                        <td class="table-actions">
                            <form action="doCarDetail.jsp" method="post">
                                <input type="hidden" name="carId" value="<%= item.getId() %>">
                                <input type="hidden" name="startDate" value="<%= startDate %>">
                                <input type="hidden" name="endDate" value="<%= endDate %>">
                                <button class="btn btn-secondary" type="submit">Detail</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        <div style="margin-top:24px;">
            <button class="btn btn-secondary" onclick="window.location.href='selectStat.jsp'">Back</button>
        </div>
    </div>
</body>
</html>

