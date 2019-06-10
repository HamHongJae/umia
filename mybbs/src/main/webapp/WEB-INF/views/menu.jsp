<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/menu.css" />
<title>Insert title here</title>
</head>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery-3.4.0.min.js"></script>
<body>
	<div id="topmenu">
          <ul>
            <li><a href="main">Hong</a></li>
            <li><a href="profile">profile</a></li>
            <li><a href="uploadAjax">file upload</a>
            <li><a href="guestBook">guest book</a></li>
            <li><a href="minigame">mini game</a></li>
           
            <c:choose>
            	<c:when test="${ sessionScope.userId == null}">
            		<li><a href="sign_up">Sign up</a></li>
            		<li><a href="login">login</a></li>
           		</c:when>
           		<c:otherwise>
           			<li>${ sessionScope.userName } 님 환영합니다.</li>
           			<li><a href="logout">Logout</a></li>
           			</c:otherwise>
            </c:choose>
          </ul>
    </div>
    
	<br />
	<br />
</body>
</html>