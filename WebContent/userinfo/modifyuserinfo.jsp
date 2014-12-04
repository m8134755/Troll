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
	
	String userid = session.getAttribute("userid").toString();
	
	JSONObject json = new JSONObject();
	
	// request : email, pwchanged, (newpassword)
	
	String email = request.getParameter("email").toString();
	boolean passwordChanged = Boolean.valueOf(request.getParameter("pwchanged"));
		
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "";
		if(passwordChanged){
			String password = request.getParameter("password").toString();
			sql = "select password from user where user_id=?;";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userid);
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()){
				String dbpassword = rs.getString("password");
				if(!password.equals(dbpassword)){
					json.put("status", -1);
					throw new Exception();
				}
			}
			
			String newpassword = request.getParameter("newpassword").toString();
			sql = "update user set password=?, email=? where user_id=?;";
			ps = conn.prepareStatement(sql);
			ps.setString(1, newpassword);
			ps.setString(2, email);
			ps.setString(3, userid);
			}
		else{
			sql = "update user set email=? where user_id=?;";
			ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, userid);
		}
		
		int result = ps.executeUpdate();
		
		if(result > 0){
			json.put("status", 1);
		}
		else{
			json.put("status", 0);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(ps, conn);
	}
	
	out.write(json.toString());
%>