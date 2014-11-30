<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String boardid = session.getAttribute("boardid").toString();
	String listtitle = request.getParameter("listtitle");
	String history = session.getAttribute("name").toString() + "님께서 리스트(" + listtitle + ")를 추가하셨습니다.";
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into list (list_master, list_title) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, boardid);
		ps.setString(2, listtitle);
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("listtitle", request.getParameter("listtitle"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(json.toString());
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into history (history_master, history_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, boardid);
		ps.setString(2, history);
			
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
%>