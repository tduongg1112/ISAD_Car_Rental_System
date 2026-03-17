<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="model.Car, dao.CarDAO"%>
    

<%
    // Lấy dữ liệu
    int id = Integer.parseInt(request.getParameter("id"));
    String carName = request.getParameter("carName");
    String carType = request.getParameter("carType");
    String modelYear = request.getParameter("modelYear");
    String licensePlate = request.getParameter("licensePlate");
    float rentalPrice = Float.parseFloat(request.getParameter("rentalPrice"));
    String color = request.getParameter("color");
    String description = request.getParameter("description");
    
    // Tạo một đối tượng Car mới
    Car car = new Car();
    car.setId(id);
    car.setCarName(carName);
    car.setCarType(carType);
    car.setModelYear(modelYear);
    car.setLicensePlate(licensePlate);
    car.setRentalPrice(rentalPrice);
    car.setColor(color);
    car.setDescription(description);
    
    // Gọi DAO thực hiện cập nhật
    CarDAO carDAO = new CarDAO();
    boolean success = carDAO.updateCar(car);
    
    if(success){
        session.removeAttribute("selectedCar");
        response.sendRedirect("searchCar.jsp");
    } else {
        response.sendRedirect("editCar.jsp?updateError=true");
    }
%>