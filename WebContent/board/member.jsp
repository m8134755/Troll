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
	String currentuser = session.getAttribute("userid").toString();
	String newguest = request.getParameter("userid").toString();
	String master = null;
	List<String> guestlist = null;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	 JSONObject json = new JSONObject();
	
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from board where board_id=?;";
		ps = conn.prepareStatement(sql);
		ps.setInt(1, boardid);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			master = rs.getString("board_master");
			if(rs.getString("guest") != null)
			{
				guestlist = Arrays.asList(StringUtils.split(rs.getString("guest"),","));
			
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?;";
		ps = conn.prepareStatement(sql);
		ps.setString(1, newguest);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			if(newguest.equals(currentuser))
			{
				json.put("status",3);
			}
			else
			{
				if(currentuser.equals(master))
				{
					if(guestlist != null && guestlist.contains(newguest))
					{
						json.put("status",4);
					}
					else
					{
						json.put("status",1);
						json.put("memberid" , newguest);
					}
				}
				else
				{
					json.put("status", 2);
				}
			}
		}
		else
		{
			json.put("status", 0);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	
	
	
	out.write(json.toString());
	
%>