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
	String liststatus = request.getParameter("liststatus");
	String listtitle = request.getParameter("listtitle");
	String history;
	
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
			if(rs.getRow() == Integer.parseInt(liststatus) + 1){
				session.setAttribute("listid", rs.getString(2));
				session.setAttribute("beforelist", rs.getString(3));
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{	
		conn = ConnUtil.getConnection();
		
		String sql = "update list set list_title=? where list_id=?";
		ps = conn.prepareStatement(sql);	
		ps.setString(1, listtitle);
		ps.setString(2, session.getAttribute("listid").toString());
		
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	try{	
		
		history = name + "님께서 리스트(" + session.getAttribute("beforelist").toString() + ")를 리스트(" + listtitle + ")로 수정하셨습니다.";
		
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