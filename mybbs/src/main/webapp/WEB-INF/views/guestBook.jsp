<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <% request.setCharacterEncoding("UTF-8"); %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/gusetBook.css" /> 
<title>방명록 작성</title>
</head>
<body>
	<%@ include file="menu.jsp"  %>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery-3.4.0.min.js"></script>
	
	<h2>방명록 작성</h2>
	<!-- 방명록 등록 -->
	<textarea id="txta" cols="20" rows="3" name="content" wrap=hard onKeyUp="checkByteAndRow()"></textarea>
	<div class="data_count">
		<div id="msgCount">0</div> / 150자
	</div>
	<button id="insert" onclick="gbookInsert()">등록</button>

	<br />
	
	<!-- 방명록 표시 -->
	<div class="gbook">
		<div class="gbookBox">
			<div class="id">userId</div>
			<div id="content">content</div>
			<div class="date">date</div>
		</div>
		 <div id="list"></div>
		 <div id="more"></div>
		 <button id="moreBtn" onclick="more()">더 보기</button>
	</div>
	
	
	<script type="text/javascript">
	
	$(function(){
		guestBookList()
	});
	
	function guestBookList() {
		$.ajax({
			type: "post",
			url: "gbookList",
			success: function(result){
				$("#list").html(result);
			}
		});
	}
	
	function gbookInsert() {
		var content = $("#txta").val();
		console.log(content);
		var param = {"content": content};
		$.ajax({
			type: "post",
			url: "gbookInsert",
			data: param,
			success: function(){
				guestBookList();
				$("#txta").val("");
			}
		});
	}
	
	function gbookDelete(userId ,gbookId) {
		//var userId = $("input[name='userId']").val();
		console.log("userId : " + userId);
		//var gbookId = $("input[name='gbookId']").val();
		console.log("gbookId : " + gbookId);
		var param = {"userId": userId , "gbookId": gbookId};
		$.ajax({
			type: "post",
			url: "gbookDelete",
			data: param,
			success: function(){
				guestBookList();
				console.log("삭제성공");
			}
		});
	}
	
	function gbookMoreDelete(userId ,gbookId) {
		//var userId = $("input[name='userId']").val();
		console.log("userId : " + userId);
		//var gbookId = $("input[name='gbookId']").val();
		console.log("gbookId : " + gbookId);
		var param = {"userId": userId , "gbookId": gbookId};
		$.ajax({
			type: "post",
			url: "gbookDelete",
			data: param,
			success: function(){
				guestBookList();
				more();
				console.log("삭제성공");
			}
		});
	}
	
	function more() {
		//fetch('?') 서버에  ? 라는 url를 던져 다운로드 받게한다. 
		//then 은 반응올때까지 기다림
		fetch('more').then(function(response){
			response.text().then(function(text){
				document.querySelector('#more').innerHTML = text;
				var btn = document.getElementById('moreBtn');
				btn.disabled = 'disabled';
				btn.innerHTML = '더 없음';
			})
		})	
	}
	
	var limitByte = 150; //바이트의 최대크기, limitByte 를 초과할 수 없슴
	// textarea에 입력된 문자의 바이트 수를 체크
	function checkByteAndRow() {
	   var totalByte = 0;
        var message = $("#txta").val();
        for(var i = 0; i < message.length; i++) {
            var currentByte = message.charCodeAt(i);
            if(currentByte > 128) { 
            	totalByte += 2; //한글
            } else { 
            	totalByte++;
            }
        }
        // 현재 입력한 문자의 바이트 수를 체크하여 표시
        document.querySelector('#msgCount').innerHTML = totalByte;
        // 입력된 바이트 수가 limitByet를 초과 할 경우 경고창 
        if(totalByte > limitByte) {
                alert( limitByte + "자까지 전송가능합니다.");
                $("#txta").val( message.substring(0,limitByte) );
        }
        //줄 제한
        var rows = message.split('\n').length;
        console.log("rows: " + rows);
        var maxRows = 3;
        if( rows > maxRows){
            alert('3줄 까지만 표시됩니다.');
            $("#txta").val( message.split("\n").slice(0, maxRows).join("\n") );
        }
	}
	</script>
</body>
</html>