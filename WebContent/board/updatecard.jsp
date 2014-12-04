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
	String name = session.getAttribute("name").toString();
	String cardid = request.getParameter("cardid");
	String cardcontent = request.getParameter("cardcontent");
	String history;
	
	int result = 0;
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "select * from card where card_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, cardid);
		rs = ps.executeQuery();	
		
		if(rs.next()){
			session.setAttribute("beforecard", rs.getString(3));
		}

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{	
		conn = ConnUtil.getConnection();
		
		String sql = "update card set card_content=? where card_id=?";
		ps = conn.prepareStatement(sql);	
		ps.setString(1, cardcontent);
		ps.setString(2, cardid);
		
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{	
		
		history = name + "님께서 카드(" + session.getAttribute("beforecard").toString() + ")를 카드(" + cardcontent + ")로 수정하셨습니다.";
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
	out.write(json.toString());
%>