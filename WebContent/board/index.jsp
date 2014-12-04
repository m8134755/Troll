<!DOCTYPE html>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="util.ConnUtil"%>
<%@page import="java.sql.*" %>
<%@page import="org.json.simple.*" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>




<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <link rel="shortcut icon" href="/images/favicon.png">

    <title>Troll</title>

    <link href="/css/bootstrap.css" rel="stylesheet">
    <link href="/css/style_global.css" rel="stylesheet" />

</head>

<body>

    <%@ include file="/header.jsp" %>
    <%@ include file="main.jsp" %>
    <%@ include file="/footer.jsp" %>
    <script src="https://code.jquery.com/jquery-2.0.3.min.js"></script>
    <script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/script_global.js"></script>
    <script src="script.js"></script>
    
</body>
</html>