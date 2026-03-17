<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, model.ContractDetail, model.Car"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Car Revenue Detail</title>
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
        .info-grid{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }
        label{
            font-weight: 600;
            color: #1f3858;
            display: block;
            margin-bottom: 6px;
        }
        input{
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            background-color: #f0f4fb;
        }
        table{
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
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
        .total-row{
            font-weight: 600;
            text-align: right;
        }
        .actions{
            margin-top: 24px;
            text-align: center;
        }
        .btn{
            padding: 11px 24px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
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
        Car car = (Car) request.getAttribute("car");
        ArrayList<ContractDetail> contracts = (ArrayList<ContractDetail>) request.getAttribute("contracts");
        String startDate = (String) request.getAttribute("startDate");
        String endDate = (String) request.getAttribute("endDate");
        Float totalRevenue = (Float) request.getAttribute("totalRevenue");
        if(contracts == null){
            contracts = new ArrayList<>();
        }
    %>
    <div class="page">
        <h1>Car Detail</h1>
        <% if(car != null) { %>
        <div class="info-grid">
<!--            <div>
                <label>Start Date</label>
                <input type="text" value="<%= startDate %>" readonly>
            </div>
            <div>
                <label>End Date</label>
                <input type="text" value="<%= endDate %>" readonly>
            </div>-->
            <div>
                <label>Car Name</label>
                <input type="text" value="<%= car.getCarName() %>" readonly>
            </div>
            <div>
                <label>Car Type</label>
                <input type="text" value="<%= car.getCarType() %>" readonly>
            </div>
            <div>
                <label>Model Year</label>
                <input type="text" value="<%= car.getModelYear() %>" readonly>
            </div>
        </div>
        <% } %>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Contract ID</th>
                    <th>Contract Value</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                </tr>
            </thead>
            <tbody>
                <% if(contracts.isEmpty()) { %>
                    <tr>
                        <td colspan="5" style="text-align:center;">No contract in this period.</td>
                    </tr>
                <% } else { 
                        int no = 1;
                        for(ContractDetail summary : contracts) { %>
                    <tr>
                        <td><%= no++ %></td>
                        <td><%= summary.getContractId() %></td>
                        <td><%= String.format("%,.0f VND", summary.getContractValue()) %></td>
                        <td><%= summary.getRentalStartDate() %></td>
                        <td><%= summary.getRentalEndDate() %></td>
                    </tr>
                <%  } 
                   } %>
            </tbody>
            <tfoot>
                <tr>
                    <td class="total-row" colspan="5">
                        Total Revenue: <%= totalRevenue == null ? "0 VND" : String.format("%,.0f VND", totalRevenue) %>
                    </td>
                </tr>
            </tfoot>
        </table>
        <div class="actions">
            <form action="doCarStat.jsp" method="post" style="display:inline;">
                <input type="hidden" name="startDate" value="<%= startDate %>">
                <input type="hidden" name="endDate" value="<%= endDate %>">
                <button class="btn" type="submit">Back</button>
            </form>
        </div>
    </div>
</body>
</html>

