<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	String userid = session.getAttribute("userid").toString();
	
	try{
		conn = ConnUtil.getConnection();
		int result1 = 0, result2 = 0;
		
		String sql = "select gcmc_key from register_gcmc where user_id = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userid);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			result1 = 1;
		}
		
		ps.close();
		rs.close();
		
		sql = "select regID from user_device where user_id = ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userid);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			result2 = 1;
		}
		
		if(result1 == 1 || result2 == 1) json.put("status", 1);
		else json.put("status", 0);
	}catch(Exception e){
		e.printStackTrace();
		json.put("status", 0);
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
%>