<%@page import="com.ibm.db2.jcc.am.se"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	String boardid;
	JSONObject json = new JSONObject();
	
	if(session.getAttribute("boardid") == null){
		boardid = "main";
	}else{
		boardid = session.getAttribute("boardid").toString();
	}
	
	String status = boardid + request.getParameter("status");
	
	if(session.getAttribute(status)==null){
		session.setAttribute(status, 0);
	}else{
		if(Integer.parseInt(session.getAttribute(status).toString()) == 1){
			session.setAttribute(status, 0);
		}else{
			session.setAttribute(status, 1);
		}		
	}
	out.write(session.getAttribute(status).toString());
%>