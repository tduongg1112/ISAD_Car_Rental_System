<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, dao.CarStatDAO, model.CarStat"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || !"manager".equals(user.getRole())) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    ArrayList<CarStat> carStats = new ArrayList<>();
    String error = null;
    boolean searched = false;
    
    if(startDateStr == null || endDateStr == null || startDateStr.trim().isEmpty() || endDateStr.trim().isEmpty()){
        error = "Please enter date!";
    } else {
        try{
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
            if(startDate.after(endDate)){
                error = "Invalid Date";
            } else {
                searched = true;
                CarStatDAO daoObj = new CarStatDAO();
                carStats = daoObj.getCarRevenue(startDate, endDate);
            }
        } catch (IllegalArgumentException ex){
            error = "Invalid Date!";
        }
    }
    
    request.setAttribute("carStats", carStats);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
    request.setAttribute("searched", searched);
    request.setAttribute("errorMessage", error);
    
    request.getRequestDispatcher("carStat.jsp").forward(request, response);
%>

