<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/uploadAjax.css" />

<title>Insert title here</title>
</head>

<body>
<%@ include file="menu.jsp"  %>
<h2>File upload</h2>

<p> 파일올리기 : 파일드래그 앤 드랍</p>

<button class="newFolder">새폴더</button>  <div id="uploadPath">클라우드</div>

	<div class="uploadedList"></div>


<script>
$(function(){
	
	$(".uploadedList").on("dragenter dragover", function(event){
		event.preventDefault(); // 기본효과막기
	});
	
	$(".uploadedList").on("drop", function(event){
		//기본효과 막기
		event.preventDefault();
		
		//드래그된 파일 정보
		var files = event.originalEvent.dataTransfer.files;
		var file= files[0];
		
		//ajax로 전달할 폼객체
		var formData = new FormData();
		formData.append("file",file);
		
		$.ajax({
			type:"post",
			url: "${pageContext.request.contextPath}/uploadAjax",
			data: formData,
			dataType : "text",
			processData: false,
			contentType: false,
			success: function(result) {
				if(result == "saved") {
					attachList(); 
				}
			} //end success
		}); //end $.ajax
		
	}); //end drop event

	//파일삭제버튼
	$(".uploadedList").on("click",".deleteBtn",function(event){
		$.ajax({ 
			url: "${pageContext.request.contextPath}/deleteFile",
			type: "post",
			data: {fileName: $(this).attr("data-src")},
			dataType : "text",
			success: function(result){
				if(result == "deleted") {
					$(this).parent("div").remove();
					attachList(); 
				}
			}
		});
	});
	
	//폴더삭제버튼
	$(".uploadedList").on("click",".deleteFolderBtn",function(event){
		$.ajax({ 
			url: "${pageContext.request.contextPath}/deleteFolder",
			type: "post",
			data: {folderName: $(this).attr("data-src")},
			dataType : "text",
			success: function(result){
				if(result == "deleted") {
					$(this).parent("div").remove();
					attachList(); 
				}
			}
		});
	});
	//새폴더 만들기
	$(".newFolder").on("click",function(event){
		var html = "";
		html += "<div class='box'><img src='${pageContext.request.contextPath}/resources/img/folder.png' />"
		html += "<div class='inputDiv'><input type='text' value='새폴더' class='createFoler' onblur='blurEvent()' onkeydown='clickEnter()' /></div></div>";		

		$(".uploadedList").append(html);
		
	});
	var path = "";
	
	//새폴더로 경로이동
	$(".uploadedList").on("click",".folder",function(event){
		path = $(this).html() ;
		$.ajax({ 
			url: "${pageContext.request.contextPath}/goInfolder",
			type: "post",
			data: {folderName: $(this).html() },
			dataType : "text",
			success: function(uploadPath){
				uploadPath = uploadPath.substr(10);  // c:\upload\  자르기
				$('#uploadPath').html(uploadPath);
				
				attachList();
			}
		});
	});
	
	//폴더 나가기
	$(".uploadedList").on("click",".folderOut",function(event){
		$.ajax({ 
			url: "${pageContext.request.contextPath}/goOutfolder",
			type: "post",
			success: function(uploadPath){
				if (uploadPath.length < 10 ){
					uploadPath = "클라우드";
				} else{
					uploadPath = uploadPath.substr(10); // c:\upload\  자르기
				}
				$('#uploadPath').html(uploadPath);
				
				attachList(); 
			}
		});
	});
	
	attachList(); 
	
	  // blur 와 click 중복방지
}); //end $(function()

//엔터처리
var created = false;
function clickEnter(){
    // 엔터키의 코드는 13입니다.
    if(event.keyCode == 13){
    	created = true;
    	folderCreate();
    }
}
function blurEvent(){
	if ( created == true){
		console.log("중복방지");
		created = false;
		return ;
	}
	folderCreate();
	
}

//blurEvent() clickEnter() 로 넘어옴
function folderCreate(){
	var folderName = $('.createFoler').val();
	
	$.ajax({
		type: "post",
		url: "${pageContext.request.contextPath}/createFolder",
		data: {folderName: folderName},
		dataType : "text",
		success : function(result){
			if( result == "created"){
				attachList(); 
			} else if (result == "exists") {
				alert("같은 폴더명 존재");
				attachList(); 
			} 
		}
	});
}

function attachList(){
	$.ajax({
		type: "post",
		url: "${pageContext.request.contextPath}/attachList",
		success : function(list){
			var html = "";
			var temp = "";
			$(list).each(function(){
				var fileInfo = getFileInfo(this);
				if( checkFolder(this) ){
					temp = html;
					html = "";
					html = "<div class='box'><img src='${pageContext.request.contextPath}/resources/img/folder.png' />"
					html += "<a href='#' class='folder'>" + fileInfo.fileName + "</a>";
					html += "<button class='deleteFolderBtn' data-src='" + fileInfo.fullName + "'>삭제</button></div>";
					html += temp;
				} else{
					html += "<div class='box'><img src='"+ fileInfo.imgsrc +"' />"
					html += "<a href='"+ fileInfo.getLink+"'>"
							+ fileInfo.fileName + "</a>";
					html += "<button class='deleteBtn' data-src='" + fileInfo.fullName + "'>삭제</button></div>";
				}
			});
			
			//폴더 나가기
			temp = html;
			html = "";
			
			html += "<div class='box'><a href='#' class='folderOut'>"
			html += "<img src='${pageContext.request.contextPath}/resources/img/folderOut.png' />"
			html += "</a></div>";
			html += temp;
			
			$(".uploadedList").empty();		
			$(".uploadedList").append(html);
		}
	});
}
	
function getOriginalName(fileName) { //이미지가 아닌 첨부파일은 글자로
	if( checkImageType(fileName)){
		return;
	}
	//uuid 제거
	return fileName.substr(fileName.indexOf("_")+1);
}

function getImageLink(fileName){
	if(!checkImageType(fileName)) {
		return ; 
	}
	//이미지 파일이면  썸네일네임에서 파일네임 뽑아냄
	fileName = "/" + fileName.substr(3); //s_ 제거
	return fileName;
}

function checkImageType(fileName){
	var pattern = /jpg|gif|png|jpeg/i; //ignore case(대소문자 무관)
	return fileName.match(pattern); //규칙이 맞으면 true
}

function checkFolder(fileName){
	var pattern = /f_/i; //ignore case(대소문자 무관)
	return fileName.match(pattern); //규칙이 맞으면 true
}

function getFileInfo(fullName){ 
	var fileName, imgsrc, getLink, fileLink;
	if( checkImageType(fullName) ){
		imgsrc = "${pageContext.request.contextPath}/displayFile?fileName=" + fullName;
		//이미지일때는 파일명 /s_~~~~로 날아옴
		fileLink = getImageLink(fullName);
		getLink = "${pageContext.request.contextPath}/displayFile?fileName=" + getImageLink(fullName);
	} else if(checkFolder(fullName)) {
		//  /f_b20b6202-2708-47d4-96ea-043c7c0513c6_새폴더
		fileLink = fullName;
		imgsrc = "${pageContext.request.contextPath}/resources/img/folder.png";
		fileName = fullName.substr(fullName.lastIndexOf("_") + 1);
	} else {
		imgsrc = "${pageContext.request.contextPath}/resources/img/file.jpg";
		fileLink = fullName;
		getLink = "${pageContext.request.contextPath}/displayFile?fileName=" + fullName;
	} 
	fileName = fullName.substr(fullName.lastIndexOf("_") + 1);

	return {fileName: fileName, imgsrc: imgsrc,
			getLink: getLink, fullName: fullName}
	
	//fullName: UUID 있음 이미지라면 s_,f_ 도있음 
	//imgsrc : imgsrc 용 썸네일넘어옴  //  <img src='"+ fileInfo.imgsrc +"' />
	
	//fileName: UUID 없는 파일네임
	//getLick : 다운로드용   
	//"<a href='"+ fileInfo.getLink+"'>" + fileInfo.fileName + "</a>";
}

</script>
	
</body>
</html>