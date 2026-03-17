<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, dao.ContractDAO, model.Contract"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    String homePage = "manager".equals(user.getRole()) ? "managerHome.jsp" : "salesStaffHome.jsp";
    
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";
    
    ContractDAO dao = new ContractDAO();
    ArrayList<Contract> contracts = dao.searchContracts(keyword);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f7fa;
            color: #333;
            margin: 0;
            padding: 40px 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h2 { margin: 0; color: #1a365d; }
        .search-box {
            display: flex;
            gap: 10px;
        }
        input[type="text"] {
            padding: 10px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            width: 250px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }
        .btn-primary:hover { background-color: #2563eb; }
        .btn-secondary {
            background-color: #e2e8f0;
            color: #475569;
        }
        .btn-secondary:hover { background-color: #cbd5e1; }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .data-table th, .data-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
        }
        .data-table th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
        }
        .data-table tr:hover { background-color: #f8fafc; }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-booked { background: #dbeafe; color: #1e40af; }
        .status-deposited { background: #ffedd5; color: #c2410c; }
        .status-finished { background: #dcfce7; color: #166534; }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #64748b;
        }
        .footer-actions {
            margin-top: 30px;
            text-align: left;
        }
        .action-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        .action-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Manage Orders (Contracts)</h2>
            <form action="manageOrders.jsp" method="get" class="search-box">
                <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search by Client Name or Phone...">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>

        <% if (contracts == null || contracts.isEmpty()) { %>
            <div class="empty-state">
                <p>No contracts found matching your search.</p>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Created Date</th>
                        <th>Client Name</th>
                        <th>Phone</th>
                        <th>Total Value</th>
                        <th>Deposit</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Contract c : contracts) { 
                        String badgeClass = "status-booked";
                        if("Deposited".equals(c.getStatus())) badgeClass = "status-deposited";
                        else if("Finished".equals(c.getStatus())) badgeClass = "status-finished";
                    %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td><%= c.getCreatedDate() %></td>
                        <td><%= c.getClientName() %></td>
                        <td><%= c.getClientPhone() %></td>
                        <td><%= String.format("%,.0f", c.getContractValue()) %>₫</td>
                        <td><%= String.format("%,.0f", c.getDepositAmount()) %>₫</td>
                        <td><span class="status-badge <%= badgeClass %>"><%= c.getStatus() %></span></td>
                        <td>
                            <a href="contractDetail.jsp?id=<%= c.getId() %>" class="action-link">View Details</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <div class="footer-actions">
            <button class="btn btn-secondary" onclick="window.location.href='<%= homePage %>'">Back to Home</button>
        </div>
    </div>
</body>
</html>
