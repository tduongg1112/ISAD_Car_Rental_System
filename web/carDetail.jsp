<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="model.Car, dao.CarDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Car Detail</title>
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
            background-color: #f8fbff;
        }
        textarea{
            min-height: 100px;
            resize: vertical;
            grid-column: 1 / span 2;
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
    </style>
</head>
<body>
    <%
        model.Member user = (model.Member) session.getAttribute("user");
        if(user == null || !"manager".equals(user.getRole())) {
            response.sendRedirect("login.jsp?err=timeout");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarById(id);
        session.setAttribute("selectedCar", car);
    %>
    <div class="page">
        <h1>Car Detail</h1>
        <% if(car != null) { %>
            <div class="form-grid">
                <div>
                    <label>ID</label>
                    <input type="text" value="<%= car.getId() %>" readonly>
                </div>
                <div>
                    <label>Car Name</label>
                    <input type="text" value="<%= car.getCarName() %>" readonly>
                </div>
                <div>
                    <label>Car Type</label>
                    <input type="text" value="<%= car.getCarType() %>" readonly>
                </div>
                <div>
                    <label>Model Year</label>
                    <input type="text" value="<%= car.getModelYear() %>" readonly>
                </div>
                <div>
                    <label>License Plate</label>
                    <input type="text" value="<%= car.getLicensePlate() %>" readonly>
                </div>
                <div>
                    <label>Rental Price</label>
                    <input type="text" value="<%= String.format("%,.0f VND", car.getRentalPrice()) %>" readonly>
                </div>
                <div>
                    <label>Color</label>
                    <input type="text" value="<%= car.getColor() %>" readonly>
                </div>
                <textarea readonly><%= car.getDescription() %></textarea>
            </div>
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='editCar.jsp'">Edit</button>
                <button class="btn btn-secondary" onclick="window.location.href='searchCar.jsp'">Back</button>
            </div>
        <% } else { %>
            <p>Không tìm thấy thông tin xe.</p>
        <% } %>
    </div>
</body>
</html>