<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String boardid = request.getParameter("boardid");
	String userid = session.getAttribute("userid").toString();
	int num = Integer.parseInt(boardid);
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from board where board_master=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			if(rs.getRow() == num+1){
				session.setAttribute("boardtitle", rs.getString("board_title"));
				session.setAttribute("boardid", rs.getString("board_id"));
			}
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(json.toString());
%>