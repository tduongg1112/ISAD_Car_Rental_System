<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="model.Contract, model.ContractDetail, dao.ContractDAO"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String carIdStr = request.getParameter("carId");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String clientName = request.getParameter("clientName");
    String clientPhone = request.getParameter("clientPhone");
    String contractValueStr = request.getParameter("contractValue");
    
    try {
        int carId = Integer.parseInt(carIdStr);
        float contractValue = Float.parseFloat(contractValueStr);
        java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
        java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
        
        Contract contract = new Contract();
        contract.setClientName(clientName);
        contract.setClientPhone(clientPhone);
        contract.setContractValue(contractValue);
        contract.setDepositAmount(0); // Deposit is 0 initially
        contract.setStatus("Booked");
        contract.setMemberId(user.getId());
        
        ContractDetail detail = new ContractDetail();
        detail.setCarId(carId);
        detail.setRentalStartDate(startDate);
        detail.setRentalEndDate(endDate);
        
        ContractDAO dao = new ContractDAO();
        boolean success = dao.createContract(contract, detail);
        
        if(success) {
            // Redirect to deposit screen
            response.sendRedirect("deposit.jsp?contractId=" + contract.getId() + "&total=" + contractValue + "&client=" + java.net.URLEncoder.encode(clientName, "UTF-8"));
        } else {
            request.setAttribute("errorMessage", "Failed to book car. Please try again or the car is no longer available.");
            request.getRequestDispatcher("bookCar.jsp").forward(request, response);
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "System Error occurred!");
        request.getRequestDispatcher("bookCar.jsp").forward(request, response);
    }
%>
