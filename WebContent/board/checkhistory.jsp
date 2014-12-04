<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String boardid = session.getAttribute("boardid").toString();
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from history where history_master=? order by created_at desc limit 10";
		ps = conn.prepareStatement(sql);
		ps.setString(1, boardid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			json = new JSONObject();
			json.put("historycontent", rs.getString("history_content"));
			ja.add(json);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(ja.toString());
	
%>