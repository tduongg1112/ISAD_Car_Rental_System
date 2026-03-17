<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="model.Member, dao.MemberDAO"%>

<%
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    Member member = new Member(user, pass);
    MemberDAO memberDAO = new MemberDAO();
    
    boolean loginSuccess = memberDAO.checkLogin(member);
    
    if(loginSuccess) {
        session.setAttribute("user", member); 
        
        if(member.getRole().equals("manager")) {
            response.sendRedirect("managerHome.jsp");
        } else if (member.getRole().equals("salestaff")) {
            response.sendRedirect("salesStaffHome.jsp");
        } else {
            response.sendRedirect("login.jsp?err=fail");
        }
        
    } else {
        response.sendRedirect("login.jsp?err=fail");
    }
%>