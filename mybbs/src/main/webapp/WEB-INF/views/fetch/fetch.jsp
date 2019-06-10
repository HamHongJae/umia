<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/resources/fetch/fetch.js"></script>
</head>
<body>
	<ul id="nav">
		
	</ul>
	
	
	<article>
	</article>
	
	
	<script>
		function fetchPage(name) {
			//fetch('?') 서버에  ? 라는 url를 던져 다운로드 받게한다. 
			//then 은 반응올때까지 기다림
			fetch(name).then(function(response){
				response.text().then(function(text){
					document.querySelector('article').innerHTML = text;
				})
			})	
		}
		
		if (location.hash) {
			fetchPage(location.hash.substr(2));
		} else {
			fetchPage('welcome');
		}
		
		
		fetch('list').then(function(response){
			response.text().then(function(text){
				console.log(text);
				var items = text.split(',');
				var tags = '';
				var i = 0;
				while(i < items.length) {
					var item = items[i];
					item.trim();
					var tag ='<li><a href="#!'+item +'" onclick="fetchPage(\''+item+'\')">' +item+'</a></li>';
				//	<li><a href="#!html" onclick="fetchPage('html')">html</a></li>
					tags = tags + tag ;
					i++;
				}
				document.querySelector('#nav').innerHTML = tags;
			})
		});	
		
	</script>
	
</body>
</html>