<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
 자료업로드 페이지
 
<form action="upload" method="post"
enctype="multipart/form-data" target="iframe">
	<input type="file" name="file" />
	<input type="submit" value="업로드" />
</form>
<iframe name="iframe"></iframe>
</body>
</html>