<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String listid = request.getParameter("listid");
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from card where card_master=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, listid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			json = new JSONObject();
			json.put("cardcontent", rs.getString("card_content"));
			json.put("cardid", rs.getString("card_id"));
			ja.add(json);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(ja.toString());
%>