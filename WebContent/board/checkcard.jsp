<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="util.ConnUtil" %>
<%@page import="org.json.simple.*" %>
<%@page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String boardid = session.getAttribute("boardid").toString();
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	int result;
	String sql;
	ArrayList<String> array = new ArrayList<String>();
	
	try{
		conn = ConnUtil.getConnection();
		sql = "select * from card where card_master in (select list_id from list where list_master = ?)";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, boardid);
		
		
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
			sql = "select * from card where card_master in (select list_id from list where list_master = ?)";
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, boardid);
			
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
	
	try{
		conn = ConnUtil.getConnection();
		sql = "select * from card where card_master in (select list_id from list where list_master=?)";
		ps = conn.prepareStatement(sql);
		ps.setString(1, boardid);
		
		rs = ps.executeQuery();
		
		while(rs.next()){
			json = new JSONObject();
			json.put("cardmaster", rs.getString("card_master"));
			json.put("cardcontent", rs.getString("card_content"));
			json.put("cardid", rs.getString("card_id"));
			ja.add(json);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	out.write(ja.toString());
%>