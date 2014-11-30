<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	
%>
<div class="title">
    <div class="container">
    	<%= session.getAttribute("boardtitle") %>
    </div>
</div>

<div class="col-md-2 col-xs-3">
	<ul class="list-unstyled"  id = "history">
	</ul>
</div>

<article class="container">
	<div class="row">
		<div class="col-md-12" id="userlist">
		</div>
	</div>
</article>
