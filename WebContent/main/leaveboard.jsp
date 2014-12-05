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
	String userid = session.getAttribute("userid").toString();
	int boardid = Integer.parseInt(request.getParameter("boardid").toString());
	int result = 0;
	String[] guest=null;
	int index = 0;
	String guestlist=null;
	
	
	Connection conn = null;
	PreparedStatement ps = null;
	Statement stmt=null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "select * from board where board_id = ?;";
		
		ps = conn.prepareStatement(sql);
		
		ps.setInt(1,boardid);
			
		rs = ps.executeQuery();
		
		if(rs.next()){
			if(rs.getString("guest") != null)
			{
				guestlist = rs.getString("guest");
				
				if(guestlist.contains(","))
				{
					guest = StringUtils.split(rs.getString("guest"),',');
				}
			}
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	if(guest.length != 2)
	{
		if(guest != null && guest.length > 1)
		{
			for(int i=0 ;i < guest.length ; i++)
			{
				if(guest[i].equals(userid))
				{
					guest[i] = null;
					index++;
				}
			}
			if(index > 1)
			{
				String[] deletelist = new String[index+1];
				for(int i=0 ; i<guest.length ; i++)
				{
					for(int j=0 ; j<=index ; j++)
					{
						if(guest[i].equals(null) == false)
						{
							deletelist[j] = guest[i];
						}
					}
				}
				guestlist = StringUtils.join(deletelist,",");
			}
			else
			{
				guestlist = null;
			}
		}
		else
		{
			guestlist = null;
		}
	}
	else
	{
		if(guest[0].equals(userid))
		{
			guestlist = guest[1];
		}
		else if(guest[1].equals(userid))
		{
			guestlist = guest[0];
		}
	}
	try{
		conn = ConnUtil.getConnection();
		
		String sql = "update board set guest = ? where board_id = ?;";
		
		ps = conn.prepareStatement(sql);
		
		
		ps.setString(1,guestlist);
		ps.setInt(2, boardid);
			
		result = ps.executeUpdate();
		
		if(result > 0){
			json.put("boardid", request.getParameter("boardid"));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(json.toString());
%>