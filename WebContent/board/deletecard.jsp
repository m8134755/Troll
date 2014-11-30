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
	String cardtitle;
	String history;
	
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	String cardid = request.getParameter("cardid");
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from card where card_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, cardid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			cardtitle = rs.getString(3);
			history = name + "님께서 카드(" + cardtitle + ")를 삭제하셨습니다.";
			session.setAttribute("history", history);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "delete from card where card_id= ?";
		
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, cardid);
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("cardid", cardid);
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
		ps.setString(2, session.getAttribute("history").toString());
			
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
%>