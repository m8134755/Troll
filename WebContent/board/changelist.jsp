<%@page import="java.util.Collection"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
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
	String beforearrayfirst = request.getParameter("beforearrayfirst");
	String beforearraysecond = request.getParameter("beforearraysecond");
	String afterarrayfirst = request.getParameter("afterarrayfirst");
	String afterarraysecond = request.getParameter("afterarraysecond");
	String check = request.getParameter("check");
	String endarray = request.getParameter("endarray");
			
	int result;
	int maximum = Integer.MAX_VALUE;
	ArrayList<String> array = new ArrayList<String>();
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	String sql;
	
	if(Integer.parseInt(check) == 2){
		try{
			conn = ConnUtil.getConnection();
			sql = "update list set list_id='0' where list_id=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, beforearrayfirst);
			
			result = ps.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
		}
		
		try{
			sql = "update list set list_id=? where list_id=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, beforearrayfirst);
			ps.setString(2, afterarrayfirst);
			
			result = ps.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			
		}
		
		try{
			sql = "update list set list_id=? where list_id='0'";
			ps = conn.prepareStatement(sql);
			ps.setString(1, afterarrayfirst);
			
			result = ps.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnUtil.close(rs, ps, conn);
		}			
	}else if(beforearraysecond.equals(afterarrayfirst)){
		try{
			conn = ConnUtil.getConnection();
			sql = "select * from list where list_master= ? and list_id >= ? limit ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, boardid);
			ps.setInt(2, Integer.parseInt(beforearrayfirst));
			ps.setInt(3, Integer.parseInt(check));
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				for(int i=0; i<Integer.parseInt(check); i++){
					if(i==0){
						try{
							sql = "update list set list_id=0 where list_id=?";
							ps = conn.prepareStatement(sql);
							ps.setString(1, beforearrayfirst);
							session.setAttribute("beforechange", rs.getString(2));
							
							result = ps.executeUpdate();
							rs.next();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
						}			
					}else{
						try{
							sql = "update list set list_id=? where list_id=?";
							ps = conn.prepareStatement(sql);
							ps.setString(1, session.getAttribute("beforechange").toString());
							ps.setString(2, rs.getString(2));
							session.setAttribute("beforechange", rs.getString(2));
							
							result = ps.executeUpdate();
							rs.next();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
						}			
					}
				}
			}
			try{
				sql = "update list set list_id=? where list_id=0";
				ps = conn.prepareStatement(sql);
				ps.setString(1, session.getAttribute("beforechange").toString());
				
				result = ps.executeUpdate();
				rs.next();
				
			}catch(Exception e){
				e.printStackTrace();
			}finally{
			}		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnUtil.close(rs, ps, conn);
		}			
	}else if(afterarraysecond.equals(beforearrayfirst)){
		try{
			conn = ConnUtil.getConnection();
			sql = "select * from list where list_master= ? and list_id >= ? limit ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, boardid);
			ps.setInt(2, Integer.parseInt(beforearrayfirst));
			ps.setInt(3, Integer.parseInt(check));
			
			rs = ps.executeQuery();
			while(rs.next()){
				session.setAttribute("endofarray", rs.getInt(2));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
		}		
		try{
			sql = "select * from list where list_master= ? and list_id >= ? limit ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, boardid);
			ps.setInt(2, Integer.parseInt(beforearrayfirst));
			ps.setInt(3, Integer.parseInt(check));
			
			rs = ps.executeQuery();
				
			for(int i=0; i<Integer.parseInt(check)-1; i++){	
				rs.next();
				try{
					sql = "update list set list_id=0 where list_id=?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, session.getAttribute("endofarray").toString());
					
					result = ps.executeUpdate();
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
				}
				try{
					sql = "update list set list_id=? where list_id=?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, session.getAttribute("endofarray").toString());
					ps.setString(2, rs.getString(2));
					session.setAttribute("beforechange", rs.getString(2));
					
					result = ps.executeUpdate();
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
				}		
				try{
					sql = "update list set list_id=? where list_id=0";
					ps = conn.prepareStatement(sql);
					ps.setString(1, session.getAttribute("beforechange").toString());
					
					result = ps.executeUpdate();
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
				}	
			}
				
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnUtil.close(rs, ps, conn);
		}			
	}
	
	try{
		conn = ConnUtil.getConnection();
		sql = "select * from card where card_master in (select list_id from list where list_master = ? and list_id >= ? and list_id <= ?)";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, boardid);
		ps.setInt(2, Integer.parseInt(beforearrayfirst));
		ps.setInt(3, Integer.parseInt(endarray));
		
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			array.add(Integer.toString(rs.getInt(2)));
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	Collections.sort(array);
				
		
	for(int i=0; i<array.size(); i++){
		try{
			conn = ConnUtil.getConnection();
			sql = "select * from card where card_master in (select list_id from list where list_master = ? and list_id >= ? and list_id <= ?)";
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, boardid);
			ps.setInt(2, Integer.parseInt(beforearrayfirst));
			ps.setInt(3, Integer.parseInt(endarray));
			
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				if(rs.getRow()-1 == i){
					if(Integer.toString(rs.getInt(2)).equals(array.get(i))){
						break;
					}
					else{
						try{
							sql = "update card set card_id=0 where card_id=?";
							ps = conn.prepareStatement(sql);
							ps.setString(1, array.get(i));
							
							result = ps.executeUpdate();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
						}
						try{
							sql = "update card set card_id=? where card_id=?";
							ps = conn.prepareStatement(sql);
							ps.setString(1, array.get(i));
							ps.setString(2, Integer.toString(rs.getInt(2)));	
							
							result = ps.executeUpdate();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
						}
						try{
							sql = "update card set card_id=? where card_id=0";
							ps = conn.prepareStatement(sql);
							ps.setString(1, Integer.toString(rs.getInt(2)));
							
							result = ps.executeUpdate();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
						}
						break;
					}
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnUtil.close(rs, ps, conn);
		}
	}
	
	
		
%>