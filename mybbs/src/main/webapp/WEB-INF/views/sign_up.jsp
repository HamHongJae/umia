<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sign_up.css" /> 
<title>Insert title here</title>
</head>
<body>
	<%@ include file="menu.jsp"  %>
	<div>
	
	<form action="sign_up.do" method="post">
		<h1>회원가입</h1>
		<div>
			<label>아이디</label><input type="text" name="userId" id="userId" placeholder="아이디" autocomplete="off" required="required" />
			 &nbsp;
		 	<button onclick="openChild()" >중복검사</button>
		</div>
		<div>
			<label>비밀번호</label><input type="password" name="userPassword" placeholder="비밀번호" required="required" /> 
		</div>
		<div>
			<label>이름</label><input type="text" name="userName" placeholder="이름" /> 
		</div>
		<div>
			<label>성별</label>
			<input type="radio" name="userGender" checked="checked" /> 남 
			<input type="radio" name="userGender" /> 여	 
		</div>
		<div>	
			<label>이메일</label><input type="text" name="userEmail" />
		</div>
		
		<input id="btn" type="submit" value="회원가입"/>
	</form>

	</div>

</body>
<script type="text/javascript">

function openChild() {
    window.open("idCheck",
            "중복검사", "width=570, height=350, left=100, top=100,resizable = no, scrollbars = no");    
}

</script>
</html>