<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, model.Car"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Car</title>
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
            margin: 0 0 24px 0;
            color: #1f3858;
        }
        .search-bar{
            display: flex;
            gap: 12px;
            align-items: flex-end;
            margin-bottom: 20px;
        }
        .search-bar label{
            font-weight: 600;
            color: #1f3858;
        }
        .search-bar input[type="text"]{
            flex: 1;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            font-size: 15px;
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
        .btn-primary:hover{
            background-color: #0f4d8c;
        }
        table{
            width: 100%;
            border-collapse: collapse;
        }
        thead{
            background-color: #1f3858;
            color: #fff;
        }
        th, td{
            padding: 12px 10px;
            border: 1px solid #dbe5f4;
            text-align: left;
        }
        tbody tr:nth-child(even){
            background-color: #f5f7fb;
        }
        .table-actions a{
            color: #175ea8;
            text-decoration: none;
            font-weight: 600;
        }
        .message{
            margin-bottom: 8px;
            color: #c62828;
        }
        .footer-actions{
            margin-top: 20px;
            text-align: right;
        }
        .footer-actions .btn{
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
        
        ArrayList<Car> carList = (ArrayList<Car>) request.getAttribute("carList");
        String keyword = (String) request.getAttribute("keyword");
        Boolean searchedFlag = (Boolean) request.getAttribute("searched");
        boolean searched = searchedFlag != null && searchedFlag;
        if(keyword == null) keyword = "";
        if(carList == null) carList = new ArrayList<>();
    %>
    <div class="page">
        <h1>Manage Car</h1>
        <form class="search-bar" action="doSearchCar.jsp" method="get">
            <div style="flex:1;">
                <label for="carName">Name</label>
                <input type="text" id="carName" name="carName" value="<%= keyword %>" placeholder="Enter Car Name...">
            </div>
            <button class="btn btn-primary" type="submit">Search</button>
        </form>
        <% if(!searched) { %>
            <!--<div class="message" style="color:#1f3858;">Nhập tên xe và nhấn Search</div>-->
        <% } else if(carList.isEmpty()) { %>
            <div class="message">Car not found!"<%= keyword %>".</div>
        <% } %>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Car Name</th>
                    <th>Type</th>
                    <th>Model Year</th>
                    <th>Rental Price</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <% if(!carList.isEmpty()) { 
                       int no = 1;
                       for(Car car : carList) { %>
                    <tr>
                        <td><%= no++ %></td>
                        <td><%= car.getId() %></td>
                        <td><%= car.getCarName() %></td>
                        <td><%= car.getCarType() %></td>
                        <td><%= car.getModelYear() %></td>
                        <td><%= String.format("%,.0f VND", car.getRentalPrice()) %></td>
                        <td class="table-actions">
                            <a href="carDetail.jsp?id=<%= car.getId() %>">Detail</a>
                        </td>
                    </tr>
                <%   }
                   } else { %>
                    <tr>
<!--                        <td colspan="7" style="text-align:center;">
                            <%--<%= searched ? "Không có dữ liệu."%>--%>
                        </td>-->
                    </tr>
                <% } %>
            </tbody>
        </table>
        <div class="footer-actions">
            <button class="btn" onclick="window.location.href='managerHome.jsp'">Back</button>
        </div>
    </div>
</body>
</html>