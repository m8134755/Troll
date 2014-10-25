<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	if(session.getAttribute("name") != null){ %>
	<script>location.replace("/main");</script>
<%
	}

	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0);
	
	String agent = request.getHeader("User-Agent");
	System.out.println(agent + " from " + request.getRemoteAddr());
	if(agent.indexOf("Trident") != -1) response.sendRedirect("/error/notsupport/");
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Troll</title>

    <link href="/css/bootstrap.css" rel="stylesheet">

    <link href="/css/signin.css" rel="stylesheet" />
    <link href="/css/style_global.css" rel="stylesheet" />
	<link href="/css/animate.css" rel="stylesheet" />
    <link href="style.css" rel="stylesheet" />

  </head>

  <body>
    <div class="container">
      <img src="/images/ims_logo.png" id="mainimage"/>
      
      <form class="form-signin" method="post" id="animated">
	        <input id="input_id" name="userid" type="text" class="form-control" placeholder="ID" required autofocus>
   		    <input id="input_password" name ="password" type="password" class="form-control" placeholder="Password" required>
        <button class="btn btn-lg btn-primary btn-block" id="login" type="submit">로그인</button>
        <button class="btn btn-lg btn-default btn-block" id="join" type="button">회원 가입</button>
      </form>
      
      <div class="text-center">
   	  	<a data-toggle="modal" data-target=".modal">아이디 / 비밀번호 찾기</a> 
	  </div>
    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    
    <script src="https://code.jquery.com/jquery-2.0.3.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/sha256.js"></script>
    <script src="script.js"></script>
    
  </body>
</html>
