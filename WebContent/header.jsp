<%@ 
	page contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
%>

<%
	if(request.getSession(false) == null || session.getAttribute("name") == null){
		response.sendRedirect("/login");
		return;
	}
%>

<!-- Fixed navbar -->
    <header class="navbar navbar-default navbar-fixed-top" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a href="/main"><img class="navbar-brand" src="/images/ims_logo.png" /></a>
            </div>
            <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li class="dropdown" id="nav-book">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">메뉴 <b class="caret"></b></a>
                        <ul class="dropdown-menu" id="boardlist">
                        </ul>
                    </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                	<li class="dropdown" id="nav-userinfo">
                		<a href="#" class="dropdown-toggle" data-toggle="dropdown" id="name">
                		<% out.write(session.getAttribute("name").toString()); %>
                		<b class="caret"></b></a>
                		<ul class="dropdown-menu">
                			<li><a href="/userinfo">내 정보</a></li>
                			<li><a href="javascript:location.replace('/logout.jsp');">로그아웃</a></li>
                		</ul>
                	</li>
                    <li class="dropdown" id="nav-appinfo">
                    	<a href="#" class="dropdown-toggle" data-toggle="dropdown" id="info">내역<b class="caret"></b></a>
                    	<ul class="dropdown-menu" id="historylist">
                    	</ul>
                    </li>
                </ul> 
            </div><!--/.nav-collapse -->
        </div>
    </header>
    