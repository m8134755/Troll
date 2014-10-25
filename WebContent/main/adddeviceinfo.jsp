<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.*"%>

    
<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	
	String userid = session.getAttribute("userid").toString();
	String username = session.getAttribute("name").toString();
	String devicename = request.getParameter("devicename").toString();
	String manufacturer = request.getParameter("manufacturer").toString();
	String regid = request.getParameter("regid").toString();
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		if(regid.isEmpty()){
			json.put("status", 0);
			throw new Exception("android user name " + username + "'s registration id is null");
		}
		
		String sql = "select * from user_device where regid = ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, regid);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			json.put("status", -1);
		}
		else{
			sql = "insert into user_device (user_id, user_name, device_model, regID, device_manufacturer) values(?,?,?,?,?);";
			ps = conn.prepareStatement(sql);
			
			ps.setString(1, userid);
			ps.setString(2, username);
			ps.setString(3, devicename);
			ps.setString(4, regid);
			ps.setString(5, manufacturer);
			
			if(ps.executeUpdate() > 0) json.put("status", 1);
			else json.put("status", 0);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
	
%>