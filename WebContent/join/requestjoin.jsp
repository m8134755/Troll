<%@page
	import="com.sun.org.apache.xalan.internal.xsltc.compiler.Pattern"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="util.ConnUtil"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.sql.*"%>


<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String userid = request.getParameter("userid").toString();
	String pwd = request.getParameter("password").toString();
	String pwdconfirm = request.getParameter("pwdconfirm").toString();
	String name = request.getParameter("name").toString();
	String email = request.getParameter("email").toString();
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	
	// request : userid, password, name, email
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into user (user_id, password, name, email) values (?, ?, ?, ?);";
			
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, request.getParameter("userid"));
		ps.setString(2, request.getParameter("password"));
		ps.setString(3, name);
		ps.setString(4, request.getParameter("email"));
			
		result = ps.executeUpdate();
			
		if(result > 0){
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