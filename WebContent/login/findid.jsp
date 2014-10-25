<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="util.ConnUtil" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String username = request.getParameter("username").toString();
	String userclass = request.getParameter("userclass").toString();
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where name = ? and class_num = ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, username);
		ps.setString(2, userclass);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			String[] namelist = {username};
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