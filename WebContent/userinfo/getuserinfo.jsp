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
	
	String userid = session.getAttribute("userid").toString();
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?;";
		ps = conn.prepareStatement(sql);
		
		ps.setString(1, userid);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			json.put("userid", userid);
			
			String test = rs.getString("name");
			
			json.put("username", rs.getString("name"));
			json.put("email", rs.getString("email"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
%>