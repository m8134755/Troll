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
	String memberid = request.getParameter("memberid").toString();
	String id = session.getAttribute("userid").toString();
	String currentusername=null;
	String membername = null;
	String history;
	String[] guestlist=null;
	String guest;
	String[] deleteguest=null;
	String delete=null;
	String master=null;
	
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
			master = rs.getString("board_master");
			if(rs.getString("guest") != null)
			{
				guestlist = StringUtils.split(rs.getString("guest"),",");
				int j=guestlist.length;
				for(int i=0 ; i< guestlist.length ; i++)
				{
					if(guestlist[i].equals(memberid))
					{
						guestlist[i] = null;
						j--;
					}
				}
				deleteguest = new String[j];
				int index=0;
				for(int i=0 ; i<guestlist.length ; i++)
				{
					if(guestlist[i] != null)
					{
						deleteguest[index] = guestlist[i];
						index++;
					}
				}
				if(j >= 1)
				{
					delete = StringUtils.join(deleteguest,",");
				}
				else
				{
					delete = null;
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, id);
		
		rs = ps.executeQuery();
		
		if(rs.next())
		{
			currentusername = rs.getString("name");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
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
		ConnUtil.close(rs, ps, conn);
	}
	try{
		if(master.equals(id))
		{
			conn = ConnUtil.getConnection();
			
			String sql = "update board set guest=? where board_id=?;";
			
			ps = conn.prepareStatement(sql);
				
			ps.setString(1, delete);
			ps.setInt(2, boardid);
				
			result = ps.executeUpdate();
			if(result == 1)
			{
				history = currentusername + "님께서 "+ membername +"(" +memberid +")"+"님을 멤버에서 삭제하셨습니다.";
				session.setAttribute("history", history);
				json.put("status", 1);
			}
			else
			{
				json.put("status", 0);
			}
		}
		else
		{
			json.put("status",2);
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
			
		ps.setInt(1, boardid);
		ps.setString(2, session.getAttribute("history").toString());
			
		result = ps.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
%>