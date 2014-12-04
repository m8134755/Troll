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
	String liststatus = request.getParameter("liststatus").toString();
	String cardcontent = request.getParameter("cardcontent").toString();
	String history = session.getAttribute("name").toString() + "님께서 카드(" + cardcontent + ")를 추가하셨습니다.";
	int result = 0;
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from list where list_master=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, boardid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			if(rs.getRow() == Integer.parseInt(liststatus)+1){
				session.setAttribute("listid", rs.getString(2));
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into card (card_master, card_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, session.getAttribute("listid").toString());
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