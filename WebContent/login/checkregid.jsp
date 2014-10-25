<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="util.ConnUtil" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8"); //글자를 인코딩해서 JSP로 전달
											// request : 페이지가 바뀌어도 전달되는 정보 객체
	response.setCharacterEncoding("UTF-8"); // 다른 곳으로 정보를 요청.
	response.setContentType("application/json");
	
	String regId = request.getParameter("regid").toString();
	
	System.out.println(regId);
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "select user.user_id, user.admin_enum, user.name from user, user_device where regID = ? and user.user_id = user_device.user_id;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, regId);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			session.setAttribute("userid", rs.getString("user.user_id"));
			session.setAttribute("admin", rs.getInt("user.admin_enum"));
			session.setAttribute("name", rs.getString("user.name"));
			session.setMaxInactiveInterval(60 * 60);
			
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