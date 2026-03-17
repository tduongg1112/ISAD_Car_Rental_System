<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.ArrayList, model.Car, dao.CarDAO"%>
<%
    model.Member user = (model.Member) session.getAttribute("user");
    if(user == null || !"manager".equals(user.getRole())) {
        response.sendRedirect("login.jsp?err=timeout");
        return;
    }
    
    String keyword = request.getParameter("carName");
    if(keyword == null) keyword = "";
    keyword = keyword.trim();
    
    ArrayList<Car> carList = new ArrayList<>();
    boolean searched = !keyword.isEmpty();
    if(searched){
        CarDAO carDAO = new CarDAO();
        carList = carDAO.searchCarsByName(keyword);
    }
    
    request.setAttribute("carList", carList);
    request.setAttribute("keyword", keyword);
    request.setAttribute("searched", searched);
    
    request.getRequestDispatcher("searchCar.jsp").forward(request, response);
%>
