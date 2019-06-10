<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/minigame.css" /> 
<title>카드 맞추기</title>

</head>

<body>

	<%@ include file="menu.jsp"  %>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery-3.4.0.min.js"></script>
	<h2>카드 맞추기</h2>
	<br/>
	<br/>
		<h3> 남은횟수 : <span>10</span></h3> 	
	<br/>
	

	<div class="box4">
		<div class="box">
			<button onclick="changeImg('#img1')"><img id="img1" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img2')"><img id="img2" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img3')"><img id="img3" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img4')"><img id="img4" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
	</div>
		
	<div class="box4">	
		<div class="box">
			<button onclick="changeImg('#img5')"><img id="img5" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img6')"><img id="img6" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img7')"><img id="img7" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img8')"><img id="img8" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
		
	</div>
	
	<div class="box4">	
		<div class="box">
			<button onclick="changeImg('#img9')"><img id="img9" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img10')"><img id="img10" src="${pageContext.request.contextPath}/resources/img/card.jpg" /></button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img11')"><img id="img11" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
		<div class="box">
			<button onclick="changeImg('#img12')"><img id="img12" src="${pageContext.request.contextPath}/resources/img/card.jpg" /> </button>
		</div>
		
	</div>
	
	
 <script>
	var select1 = null;
 	var select2 = null;
 	var select1Id = null;
 	var select2Id = null;
 	
 	var tryNum = 10; //시도횟수
 	var sucesses = 0; //성공횟수
 	
 	var imgArr = [1,2,3,4,5,6,7,8,9,10,11,12];
 	imgArr = shuffle(imgArr);
	
	console.log('imgArr :' + imgArr);
 	
 	// 출처 : https://m.blog.naver.com/humy2833/140127333093 
 	function shuffle(arr){
 		 if(arr instanceof Array)
 		 {
 		  var len = arr.length;
 		  if(len == 1) return arr;
 		  var i = len * 2;
 		  while(i > 0)
 		  {
 		   var idx1 = Math.floor(Math.random()* len);
 		   var idx2 = Math.floor(Math.random()* len);
 		   if(idx1 == idx2) continue;
 		   var temp = arr[idx1];
 		   arr[idx1] = arr[idx2];
 		   arr[idx2] = temp;
 		   i--;
 		  }
 		 }
 		 else
 		 {
 		  alert("No Array Object");
 		 }
 		 return arr;
 	}
 	
	function changeImg(name) {
		console.log(name);
		var n = name.substr(4);
		
		console.log('n :' + n);
		
		var num = imgArr[n-1];
		if (num > 6)
			num = num - 6 ;
		
		console.log('num :' + num);
		console.log('name :' + name);
		$(name).attr("src", "${pageContext.request.contextPath}/resources/img/"+num+".jpg");   
		 	
		if (select1 == null){
			select1 = num;
			select1Id = name;
		} else  {
			if(  select1Id != name  ){
				select2 = num;
				select2Id = name;
				console.log('check()');
				checkMatch();
			}
		}
 	}
 	
 	function reset(){
 		$('#img1, #img2, #img3, #img4, #img5, #img6, #img7, #img8, #img9, #img10, #img11, #img12').attr("src", "${pageContext.request.contextPath}/resources/img/card.jpg");
 		select1 = null;
 	 	select2 = null;
 	}
 	
 	function checkMatch(){

		if(select1==null||select2==null){ //둘중 하나라도 선택이 안됬을시 무시
			console.log('choose more');
			return;
		} 
			
		if(select1 == select2){ //선택된 두 카드가 같은 그림일때
			//두 카드의 상태 정보를 매치됨으로 설정
			console.log('same');
			sucesses++;
			console.log('sucesses : ' + sucesses);
		 	setTimeout(function() {
		 		$(select1Id).hide();
			 	$(select2Id).hide();
			}, 300);
		 	
			//다시 선택할 수 있게 null값을 넣어 초기화
			select1=null;
			select1=null;
		} else{ //두 카드의 그림이 다를때
			//두 카드의 상태 정보를 다시 닫힘으로
			console.log('diff');
			//다시 선택할 수 있게 null값을 넣어 초기화
			select1=null;
			select1=null;
			
			setTimeout(function() {
				 reset();
			}, 500);
			
		}
		
		tryNum--;
		document.querySelector('span').innerHTML = tryNum;
		
		if ( sucesses >= 6 )
		{
			if( tryNum >= 0 ) {
				setTimeout(function() {
					alert( '성공!! Congratulation' );	
					window.location.reload(); //새로고침
				}, 500);
			}
		} else if ( tryNum == 0 ){
			setTimeout(function() {
			alert( '-실패-  다시 도전해 보세요' );
				window.location.reload(); //새로고침
			}, 500);
		}

	}//매치 체크
	
</script>
	
	
</body>
</html>