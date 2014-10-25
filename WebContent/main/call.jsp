<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="util.ConnUtil"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	String name = session.getAttribute("name").toString();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "select phone_num from user where name = ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, name);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			String phonenum = rs.getString(1);
			json.put("status", 1);
			json.put("phonenum", phonenum);
		}
		else{
			json.put("status", 0);
		}
		
	}catch(Exception e){
		e.printStackTrace();
		json.put("status", 0);
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
%>