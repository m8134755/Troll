<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into board (board_master, guest, board_title) values (?, ?, ?);";
		System.out.println("쿼리 날렸어요");
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, request.getParameter("boardmaster"));
		ps.setString(2, "m8134755");
		ps.setString(3, request.getParameter("boardtitle"));
			
		result = ps.executeUpdate();
		
		System.out.println("쿼리 날렸어요");
		
		if(result > 0){
			json.put("status", 1);
		}
		else{
			json.put("status", 0);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(json.toString());
%>