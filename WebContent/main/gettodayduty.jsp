<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.GregorianCalendar"%>
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
	
	try{
		conn = ConnUtil.getConnection();
		
		GregorianCalendar calendar = new GregorianCalendar();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String sql = "select * from duty where date = ?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, sdf.format(calendar.getTime()));
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			json.put("user1", rs.getString("user_id1"));
			json.put("user2", rs.getString("user_id2"));
			json.put("user3", rs.getString("user_id3"));
			json.put("user4", rs.getString("user_id4"));
			
			json.put("user1mode", rs.getInt("user1_mode"));
			json.put("user2mode", rs.getInt("user2_mode"));
			json.put("user3mode", rs.getInt("user3_mode"));
			json.put("user4mode", rs.getInt("user4_mode"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	out.write(json.toString());
%>