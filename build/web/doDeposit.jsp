<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="dao.ContractDAO"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String contractIdStr = request.getParameter("contractId");
    String depositAmountStr = request.getParameter("depositAmount");
    String total = request.getParameter("total");
    String client = request.getParameter("client");
    
    try {
        int contractId = Integer.parseInt(contractIdStr);
        float depositAmount = Float.parseFloat(depositAmountStr);
        
        ContractDAO dao = new ContractDAO();
        boolean success = dao.updateDeposit(contractId, depositAmount);
        
        if(success) {
            request.setAttribute("isSuccess", true);
        } else {
            request.setAttribute("errorMessage", "Failed to update deposit.");
            request.setAttribute("contractId", contractIdStr);
            request.setAttribute("total", total);
            request.setAttribute("client", client);
        }
    } catch(Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Invalid input or system error!");
        request.setAttribute("contractId", contractIdStr);
        request.setAttribute("total", total);
        request.setAttribute("client", client);
    }
    
    request.getRequestDispatcher("deposit.jsp").forward(request, response);
%>
