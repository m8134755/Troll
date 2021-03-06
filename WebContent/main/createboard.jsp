<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String userid = session.getAttribute("userid").toString();
	
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into board (board_master, board_title) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, userid);
		ps.setString(2, request.getParameter("boardtitle"));
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("boardtitle", request.getParameter("boardtitle"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	try{
		conn = ConnUtil.getConnection();
		
		String noitce = "보드(" + request.getParameter("boardtitle") + ")를 생성하셨습니다.";
		
		String sql = "insert into notice (notice_master, notice_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, userid);
		ps.setString(2, noitce);
			
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	out.write(json.toString());
%>