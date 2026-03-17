<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login - Rental Car Management</title>
    <style>
        *{
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }
        body{
            margin: 0;
            height: 100vh;
            background: #f5f7fb;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card{
            width: 360px;
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(31,56,88,0.18);
            text-align: center;
        }
        h1{
            color: #1f3858;
            margin-bottom: 24px;
        }
        label{
            display: block;
            text-align: left;
            color: #4b5b73;
            margin-bottom: 6px;
            font-weight: 600;
        }
        input[type="text"],
        input[type="password"]{
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #c8d5ed;
            border-radius: 6px;
            margin-bottom: 18px;
            font-size: 15px;
        }
        .btn-primary{
            width: 100%;
            background-color: #175ea8;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 12px;
            font-size: 15px;
            cursor: pointer;
        }
        .btn-primary:hover{
            background-color: #0f4d8c;
        }
        .message{
            margin-top: 10px;
            color: #c62828;
            font-size: 14px;
            min-height: 18px;
        }
    </style>
</head>
<body>
    <%
        String err = request.getParameter("err");
        String message = null;
        if("fail".equals(err)){
            message = "Wrong Username or Password";
        } else if("timeout".equals(err)){
            message = "Session time out, please log in";
        }
    %>
    <div class="card">
        <h1>Login</h1>
        <form action="doLogin.jsp" method="post">
            <label>Username</label>
            <input type="text" name="username" required>
            <label>Password</label>
            <input type="password" name="password" required>
            <button class="btn-primary" type="submit">Login</button>
        </form>
        <div class="message"><%= message == null ? "" : message %></div>
    </div>
</body>
</html>