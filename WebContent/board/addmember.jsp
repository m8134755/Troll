<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	int boardid = Integer.parseInt(session.getAttribute("boardid").toString());
	String memberid = request.getParameter("userid").toString();
	String currentuser = session.getAttribute("userid").toString();
	String currentusername = null;
	String membername = null;
	String guest = null;
	String history;
	
	int result = 0;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from board where board_id=?";
		ps = conn.prepareStatement(sql);
		ps.setInt(1, boardid);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			guest = rs.getString("guest");
			if(rs.getString("guest") == null)
			{
				guest = memberid;
			}
			else
			{
				guest = guest+ ","+memberid;
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, currentuser);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			currentusername = rs.getString("name");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, memberid);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			membername = rs.getString("name");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "update board set guest=? where board_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, guest);
		ps.setInt(2, boardid);
		
		result = ps.executeUpdate();
		
		if(result == 1)
		{
			json.put("status",1);
			history = currentusername + "님께서 " + membername +"("+ memberid +")"+ "님을 새 멤버로 추가하셨습니다.";
			session.setAttribute("history", history);
		}
		else
		{
			json.put("status",2);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	try{
		conn = ConnUtil.getConnection();
		
		String noitce = currentusername + "(" + currentuser + ")"+ "님께서 " + "보드(" +  session.getAttribute("boardtitle") + ")" +
		"에 초대하셨습니다.";
		
		String sql = "insert into notice (notice_master, notice_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, memberid);
		ps.setString(2, noitce);
			
		result = ps.executeUpdate();
		
		if(result == 1)
		{
			json.put("status",1);
			history = currentusername + "님께서 " + membername +"("+ memberid +")"+ "님을 새 멤버로 추가하셨습니다.";
			session.setAttribute("history", history);
		}
		else
		{
			json.put("status",2);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	try{
		conn = ConnUtil.getConnection();
		
		String noitce = membername + "("+ memberid +")" + "님을 " + "보드(" +  session.getAttribute("boardtitle") + ")" +
		"에 초대했습니다.";
		
		String sql = "insert into notice (notice_master, notice_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setString(1, currentuser);
		ps.setString(2, noitce);
			
		result = ps.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
	}
	
	out.write(json.toString());
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "insert into history (history_master, history_content) values (?, ?)";
		ps = conn.prepareStatement(sql);
			
		ps.setInt(1, boardid);
		ps.setString(2, session.getAttribute("history").toString());
			
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
%>