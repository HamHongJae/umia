<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="dto" items="${list}" begin="5" >
 	<div class="gbookBox">
 		 <div class="id"><c:out value="${dto.userId}" /></div>
 		 <div class="content"><div class="contentTxt"><pre><c:out value="${dto.content}"/></pre></div></div>
 		 <div class="date"><c:out value="${dto.bbsDate}" /></div>
 		 
 		 <c:if test="${sessionScope.userId == dto.userId}" >
  		 	<input type="hidden" name="userId" value='<c:out value="${dto.userId}" />' />
  		 	<input type="hidden" name="gbookId" value='<c:out value="${dto.gbookId}" />' />
  		 	<button class="deleteBtn" onclick="gbookDelete(${dto.userId},${dto.gbookId})">삭제</button>
 		 </c:if>
 	 </div>
</c:forEach>  