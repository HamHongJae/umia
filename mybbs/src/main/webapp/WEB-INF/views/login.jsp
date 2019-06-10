<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css" /> 
</head>
<body>
	<%@ include file="menu.jsp"  %>
	<div>
		<form action="loginCheck" method="post">
			<h1>Please sign in</h1>
			<input class="box" type="text" name="id" placeholder="Insert id" />
			<input class="box" type="password" name="password" placeholder="Password" />
			<input id="loginBtn" type="submit" value="login"/>
		</form>
	</div>
</body>
</html>