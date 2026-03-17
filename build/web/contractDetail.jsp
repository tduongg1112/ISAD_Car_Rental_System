<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, dao.ContractDAO, model.Contract, model.ContractDetail"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    String homePage = "manager".equals(user.getRole()) ? "managerHome.jsp" : "salesStaffHome.jsp";
    
    int contractId = 0;
    try {
        contractId = Integer.parseInt(request.getParameter("id"));
    } catch(Exception e) {}
    
    ContractDAO dao = new ContractDAO();
    Contract contract = dao.getContractById(contractId);
    ArrayList<ContractDetail> details = dao.getContractDetails(contractId);
    
    if (contract == null) {
        response.sendRedirect("manageOrders.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contract Details #<%= contract.getId() %></title>
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
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .header {
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 20px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        h2 { margin: 0; color: #1a365d; }
        .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .status-booked { background: #dbeafe; color: #1e40af; }
        .status-deposited { background: #ffedd5; color: #c2410c; }
        .status-finished { background: #dcfce7; color: #166534; }
        
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
            background: #f8fafc;
            padding: 20px;
            border-radius: 8px;
        }
        .info-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .info-label {
            font-size: 13px;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
        }
        .info-value {
            font-size: 16px;
            color: #1a365d;
            font-weight: 500;
        }
        
        h3 { color: #1a365d; margin-bottom: 15px; }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
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
        
        .totals-section {
            background: #f8fafc;
            padding: 20px;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            width: 300px;
            font-size: 15px;
        }
        .total-row.grand {
            font-weight: 700;
            font-size: 18px;
            color: #ef4444;
            border-top: 1px solid #e2e8f0;
            padding-top: 10px;
            margin-top: 5px;
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
        .btn-secondary {
            background-color: #e2e8f0;
            color: #475569;
        }
        .btn-secondary:hover { background-color: #cbd5e1; }
        .footer-actions {
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Contract Details #<%= contract.getId() %></h2>
            <%
                String badgeClass = "status-booked";
                if("Deposited".equals(contract.getStatus())) badgeClass = "status-deposited";
                else if("Finished".equals(contract.getStatus())) badgeClass = "status-finished";
            %>
            <span class="status-badge <%= badgeClass %>"><%= contract.getStatus() %></span>
        </div>

        <div class="info-grid">
            <div class="info-group">
                <span class="info-label">Client Name</span>
                <span class="info-value"><%= contract.getClientName() %></span>
            </div>
            <div class="info-group">
                <span class="info-label">Client Phone</span>
                <span class="info-value"><%= contract.getClientPhone() %></span>
            </div>
            <div class="info-group">
                <span class="info-label">Created Date</span>
                <span class="info-value"><%= contract.getCreatedDate() %></span>
            </div>
            <div class="info-group">
                <span class="info-label">Sales Staff ID</span>
                <span class="info-value">#<%= contract.getMemberId() %></span>
            </div>
        </div>

        <h3>Boooked Cars</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Car ID</th>
                    <th>Car Name</th>
                    <th>License Plate</th>
                    <th>Price / Day</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (ContractDetail d : details) { %>
                <tr>
                    <td><%= d.getCarId() %></td>
                    <td><strong><%= d.getCarName() %></strong></td>
                    <td><%= d.getLicensePlate() %></td>
                    <td><%= String.format("%,.0f", d.getRentalPrice()) %>₫</td>
                    <td><%= d.getRentalStartDate() %></td>
                    <td><%= d.getRentalEndDate() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="totals-section">
            <div class="total-row">
                <span>Contract Total:</span>
                <span><%= String.format("%,.0f", contract.getContractValue()) %>₫</span>
            </div>
            <div class="total-row">
                <span>Deposit Paid:</span>
                <span><%= String.format("%,.0f", contract.getDepositAmount()) %>₫</span>
            </div>
            <div class="total-row grand">
                <span>Remaining Balance:</span>
                <span><%= String.format("%,.0f", contract.getContractValue() - contract.getDepositAmount()) %>₫</span>
            </div>
        </div>

        <div class="footer-actions">
            <button class="btn btn-secondary" onclick="window.location.href='manageOrders.jsp'">Back to Orders List</button>
        </div>
    </div>
</body>
</html>
