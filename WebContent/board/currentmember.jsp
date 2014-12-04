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
	String[] guestlist = null;
	String[] namelist = null;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from board where board_id=?;";
		ps = conn.prepareStatement(sql);
		ps.setInt(1, boardid);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			if(rs.getString("guest") != null)
			{
				guestlist = StringUtils.split(rs.getString("guest"),",");
				namelist = StringUtils.split(rs.getString("guest"),",");
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	if(guestlist != null)
	{
		for(int i=0 ; i<guestlist.length ; i++)
		{
			try{
					conn = ConnUtil.getConnection();
					String sql = "select * from user where user_id=?;";
					ps = conn.prepareStatement(sql);
					ps.setString(1, guestlist[i]);
					rs = ps.executeQuery();
					if(rs.next())
					{
						namelist[i] = rs.getString("name");
					}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				ConnUtil.close(rs, ps, conn);
			}
		}
		try{
			for(int i=0 ; i<namelist.length ; i++){
				json = new JSONObject();
				json.put("memberid", guestlist[i]);
				json.put("member", namelist[i]);
				ja.add(json);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnUtil.close(rs, ps, conn);
		}
	}
	
	
	out.write(ja.toString());
	
%>