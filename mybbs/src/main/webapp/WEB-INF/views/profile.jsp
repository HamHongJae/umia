<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profile.css" />
<title>Insert title here</title>
</head>
<body>
	<%@ include file="menu.jsp"  %>
	<h2>프로필</h2>
		<div class="box">
		<div><span>Id</span> ${dto.userId } </div>
		<div><span>Name</span>  ${dto.userName } </div>
		<div><span>Gender</span>    ${dto.userGender } </div>
		<div><span>Email</span> ${dto.userEmail } </div>
	</div>	

<script type="text/javascript">
    
</script> 


</body>
</html>