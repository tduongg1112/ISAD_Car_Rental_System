<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, dao.CarStatDAO, dao.CarDAO, model.Car, model.ContractDetail"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || !"manager".equals(user.getRole())) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String carIdStr = request.getParameter("carId");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    
    if(carIdStr == null || startDateStr == null || endDateStr == null){
        response.sendRedirect("carStat.jsp");
        return;
    }
    
    try{
        int carId = Integer.parseInt(carIdStr);
        java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
        java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
        
        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarById(carId);
        if(car == null){
            response.sendRedirect("carStat.jsp");
            return;
        }
        
        CarStatDAO statDAO = new CarStatDAO();
        ArrayList<ContractDetail> contracts = statDAO.getContractSummary(carId, startDate, endDate);
        float totalRevenue = 0f;
        for(ContractDetail item : contracts){
            totalRevenue += item.getContractValue();
        }
        
        request.setAttribute("car", car);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("contracts", contracts);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.getRequestDispatcher("carStatDetail.jsp").forward(request, response);
    } catch (Exception ex){
        response.sendRedirect("carStat.jsp");
    }
%>

