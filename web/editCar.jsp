<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="model.Car"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Car</title>
    <style>
        *{
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }
        body{
            margin: 0;
            background: #f5f7fb;
            padding: 40px 24px;
        }
        .page{
            max-width: 720px;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.12);
        }
        h1{
            margin-top: 0;
            color: #1f3858;
            text-align: center;
        }
        .form-grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 24px;
        }
        label{
            font-weight: 600;
            color: #1f3858;
            margin-bottom: 6px;
            display: block;
        }
        input,
        textarea{
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #c8d5ed;
            font-size: 15px;
        }
        input[readonly]{
            background-color: #f0f4fb;
        }
        textarea{
            grid-column: 1 / span 2;
            min-height: 120px;
            resize: vertical;
        }
        .actions{
            margin-top: 24px;
            text-align: center;
        }
        .btn{
            padding: 11px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            margin: 0 10px;
        }
        .btn-primary{
            background-color: #175ea8;
            color: #fff;
        }
        .btn-secondary{
            background-color: #dbe5f4;
            color: #1f3858;
        }
        .error{
            color: #c62828;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || !"manager".equals(user.getRole())) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }
        
        Car car = (Car) session.getAttribute("selectedCar");
        if(car == null) {
            response.sendRedirect("searchCar.jsp?err=session_timeout");
            return;
        }
        String updateError = request.getParameter("updateError");
    %>
    <div class="page">
        <h1>Edit Car</h1>
        <% if(updateError != null) { %>
            <div class="error">Trùng biển số xe, vui lòng thử lại!</div>
        <% } %>
        <form action="doEditCar.jsp" method="post">
            <input type="hidden" name="id" value="<%= car.getId() %>">
            <div class="form-grid">
                <div>
                    <label>ID (Read only)</label>
                    <input type="text" value="<%= car.getId() %>" readonly>
                </div>
                <div>
                    <label>Car Name</label>
                    <input type="text" name="carName" value="<%= car.getCarName() %>" required>
                </div>
                <div>
                    <label>Car Type</label>
                    <input type="text" name="carType" value="<%= car.getCarType() %>" required>
                </div>
                <div>
                    <label>Model Year</label>
                    <input type="text" name="modelYear" value="<%= car.getModelYear() %>" required>
                </div>
                <div>
                    <label>License Plate</label>
                    <input type="text" name="licensePlate" value="<%= car.getLicensePlate() %>" required>
                </div>
                <div>
                    <label>Rental Price</label>
                    <input type="number" min="0" step="1000" name="rentalPrice" value="<%= car.getRentalPrice() %>" required>
                </div>
                <div>
                    <label>Color</label>
                    <input type="text" name="color" value="<%= car.getColor() %>" required>
                </div>
                <div style="grid-column: 1 / span 2;">
                    <label>Description</label>
                    <textarea name="description"><%= car.getDescription() %></textarea>
                </div>
            </div>
            <div class="actions">
                <button class="btn btn-secondary" type="button" onclick="window.location.href='carDetail.jsp?id=<%= car.getId() %>'">Cancel</button>
                <button class="btn btn-primary" type="submit">Update</button>
            </div>
        </form>
    </div>
</body>
</html>