<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복 검사 페이지</title>
</head>

<body>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery-3.4.0.min.js"></script>
	
  <br/> <br/>
 	<h1>중복검사</h1> 
 	
  
 	<input type="text" id="cInput" /> <input type="button" value="중복체크" onclick="idCheck()" />
    <br><br>
    <input type="button" id="btn" value="창닫기" onclick="setParentText()">

</body>
 <script type="text/javascript">
		//창 열릴시 부모택스트 받아오기
        function getParentText(){
            document.getElementById("cInput").value = opener.document.getElementById("userId").value;
        }
		
		
		var userId = '<%=request.getParameter("userId") %>';
		var available = '<%=request.getParameter("available") %>';
		var msg = '<%=request.getParameter("msg") %>';
		
		console.log("userId : "+ userId);
		console.log("available : "+ available);
		console.log("msg : "+ msg);
		
		//처음 창 열었다면
		if ( userId == 'null' ){
			getParentText(); 
		} else {  // 중복검사후 호출
			document.getElementById("cInput").value = userId ;
			document.querySelector('h1').innerHTML = msg;
			if (available == "false"){
				$('#btn').hide(); //버튼 숨기기

			} else{
				$('#btn').show();
			}
			
		}
		
       	//창닫기 버튼 onclick
        function setParentText(){
        	opener.document.getElementById("userId").value = document.getElementById("cInput").value;
            window.close();
        }
       	//중복체크 버튼 onclick
        function idCheck(){
         	userId = document.getElementById("cInput").value;
         	location = "idCheckDo?userId=" + userId;
        }
       	
        
       
   </script>
</html>