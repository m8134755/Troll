<%@page import="com.ibm.db2.jcc.am.re"%>
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
	String check = request.getParameter("check");
	String first = request.getParameter("first");
	String after = request.getParameter("after");
	String startarea = request.getParameter("startarea");
	String arrivalarea = request.getParameter("arrivalarea");
	String beforelist = request.getParameter("beforelist");
	String afterlist = request.getParameter("afterlist");
	int max;
	boolean bigtosmall = false;
	boolean smalltobig = false;
	
	int result;
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String sql;
	
	try{
		conn = ConnUtil.getConnection();
		sql = "select * from card where card_master = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, beforelist);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			session.setAttribute("beforemax", rs.getInt(2));
		}	
		}catch(Exception e){
			e.printStackTrace();
		}finally{
	}
	try{
		sql = "select * from card where card_master = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, afterlist);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			session.setAttribute("aftermax", rs.getInt(2));
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
	}
	
	if(Integer.parseInt(session.getAttribute("beforemax").toString()) < Integer.parseInt(session.getAttribute("aftermax").toString())){
		smalltobig = true;
	}else if(Integer.parseInt(session.getAttribute("beforemax").toString()) > Integer.parseInt(session.getAttribute("aftermax").toString())){
		bigtosmall = true;
	}else{
	}
	
	if(Integer.parseInt(check) != 0){
		if(after.equals(first)){
			for(int i=0; i<Integer.parseInt(check); i++){
				try{
					sql = "select * from card where card_master in (select list_id from list where list_master=?) and card_id >= ? limit ?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, boardid);
					ps.setInt(2, Integer.parseInt(first));
					ps.setInt(3, Integer.parseInt(check));
					
					rs = ps.executeQuery();
					
					while(rs.next()){
						if(i==rs.getRow()-1){
							if(i==Integer.parseInt(check)-1){
								break;
							}
							else{
								session.setAttribute("startarray", rs.getInt(2));
								try{
									sql = "update card set card_id='0' where card_id=?";
									ps = conn.prepareStatement(sql);
									ps.setString(1, Integer.toString(rs.getInt(2)));
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
								}
								
								while(rs.next()){
									session.setAttribute("lastarray", rs.getInt(2));
								}
								
								try{
									sql = "update card set card_id=? where card_id=?";
									ps = conn.prepareStatement(sql);
									ps.setString(1, session.getAttribute("startarray").toString());
									ps.setString(2, session.getAttribute("lastarray").toString());
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
									
								}
								
								try{
									sql = "update card set card_id=? where card_id='0'";
									ps = conn.prepareStatement(sql);
									ps.setString(1, session.getAttribute("lastarray").toString());
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
								}
							}
						}
					}
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
				}
			}
		}else{
			for(int i=0; i<Integer.parseInt(check); i++){
				try{
					sql = "select * from card where card_master in (select list_id from list where list_master=?) and card_id >= ? limit ?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, boardid);
					ps.setInt(2, Integer.parseInt(first));
					ps.setInt(3, Integer.parseInt(check));
					
					rs = ps.executeQuery();
					
					while(rs.next()){
						if(i==rs.getRow()-1){
							if(i==Integer.parseInt(check)-1){
								break;
							}
							else{
								session.setAttribute("startarray", rs.getInt(2));
								try{
									sql = "update card set card_id='0' where card_id=?";
									ps = conn.prepareStatement(sql);
									ps.setString(1, Integer.toString(rs.getInt(2)));
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
								}
								
								if(rs.next()){
									session.setAttribute("lastarray", rs.getInt(2));
								}
								
								try{
									sql = "update card set card_id=? where card_id=?";
									ps = conn.prepareStatement(sql);
									ps.setString(1, session.getAttribute("startarray").toString());
									ps.setString(2, session.getAttribute("lastarray").toString());
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
								}
								
								try{
									sql = "update card set card_id=? where card_id='0'";
									ps = conn.prepareStatement(sql);
									ps.setString(1, session.getAttribute("lastarray").toString());
									
									result = ps.executeUpdate();
									
								}catch(Exception e){
									e.printStackTrace();
								}finally{
								}
							}
						}
					}
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
				}
			}
		}
	}else{
		ConnUtil.close(rs, ps, conn);
	}	
%>