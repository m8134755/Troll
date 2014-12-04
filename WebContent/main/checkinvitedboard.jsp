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
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from board where guest like ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userid);
		
		rs = ps.executeQuery();
		
		
		
		while(rs.next()){
			json = new JSONObject();
			json.put("boardtitle", rs.getString("board_title"));
			json.put("boardid", rs.getString("board_id"));
			json.put("boardmaster",rs.getString("board_master"));
			ja.add(json);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(ja.toString());
%>