<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String phonenum = request.getParameter("phonenum").toString();
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where phone_num=?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, phonenum);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			json.put("status", 0);
			// 아이디 존재
		}
		else{
			json.put("status", 1);
			// 중복 아이디 없음
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
%>