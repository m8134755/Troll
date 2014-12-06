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
		String sql = "select board_title from board where board_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, request.getParameter("boardid"));
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			session.setAttribute("deleteboardname", rs.getString(1));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "delete from board where board_id= ?";
		
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, request.getParameter("boardid"));
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("boardid", request.getParameter("boardid"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	try{
		conn = ConnUtil.getConnection();
		
		String noitce = "보드(" + session.getAttribute("deleteboardname") + ")를 삭제하셨습니다.";
		
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