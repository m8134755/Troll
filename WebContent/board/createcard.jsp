<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String listid = request.getParameter("listid").toString();
	String cardcontent = request.getParameter("cardcontent").toString();
	int result = 0;
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into card (card_master, card_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, listid);
		ps.setString(2, cardcontent);
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("cardcontent", request.getParameter("cardcontent"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(json.toString());
%>