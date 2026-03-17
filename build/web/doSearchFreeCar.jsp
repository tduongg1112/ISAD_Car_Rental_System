<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, dao.ContractDAO, model.Car"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || (!"salestaff".equals(user.getRole()) && !"manager".equals(user.getRole()))) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    ArrayList<Car> freeCars = new ArrayList<>();
    String error = null;
    boolean searched = false;
    
    if(startDateStr == null || endDateStr == null || startDateStr.trim().isEmpty() || endDateStr.trim().isEmpty()){
        error = "Please enter dates!";
    } else {
        try{
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
            if(startDate.after(endDate)){
                error = "Start date must be before end date";
            } else {
                searched = true;
                ContractDAO daoObj = new ContractDAO();
                freeCars = daoObj.searchAvailableCars(startDate, endDate);
            }
        } catch (IllegalArgumentException ex){
            error = "Invalid Date format!";
        }
    }
    
    request.setAttribute("freeCars", freeCars);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
    request.setAttribute("searched", searched);
    request.setAttribute("errorMessage", error);
    
    request.getRequestDispatcher("searchFreeCar.jsp").forward(request, response);
%>
