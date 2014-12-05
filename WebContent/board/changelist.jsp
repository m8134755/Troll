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
	int check = Integer.parseInt(request.getParameter("check"));
	int first = Integer.parseInt(request.getParameter("first"));
	int after = Integer.parseInt(request.getParameter("after"));
	int last = Integer.parseInt(request.getParameter("last"));
	//System.out.println(first + " " + last + " " + after + " " + check);
	
	int result;
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json;
	JSONArray ja = new JSONArray();
	
	if(after-last < 0){
		for(int i=0; i<check; i++){
			try{
				conn = ConnUtil.getConnection();
				String sql = "select * from list where list_master=? and list_id >= ? limit ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, boardid);
				ps.setInt(2, first);
				ps.setInt(3, check);
				
				rs = ps.executeQuery();
				
				while(rs.next()){
					if(i==rs.getRow()-1){
						if(i==check-1){
							break;
						}
						else{
							session.setAttribute("startarray", rs.getInt(2));
							try{
								sql = "update list set list_id='0' where list_id=?";
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
								sql = "update list set list_id=? where list_id=?";
								ps = conn.prepareStatement(sql);
								ps.setString(1, session.getAttribute("startarray").toString());
								ps.setString(2, session.getAttribute("lastarray").toString());
								
								result = ps.executeUpdate();
								
							}catch(Exception e){
								e.printStackTrace();
							}finally{
								
							}
							
							try{
								sql = "update list set list_id=? where list_id='0'";
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
				ConnUtil.close(rs, ps, conn);
			}
		}
	}else{
		for(int i=0; i<check; i++){
			try{
				conn = ConnUtil.getConnection();
				String sql = "select * from list where list_master=? and list_id >= ? limit ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, boardid);
				ps.setInt(2, first);
				ps.setInt(3, check);
				
				rs = ps.executeQuery();
				
				while(rs.next()){
					if(i==rs.getRow()-1){
						if(i==check-1){
							break;
						}
						else{
							session.setAttribute("startarray", rs.getInt(2));
							try{
								conn = ConnUtil.getConnection();
								sql = "update list set list_id='0' where list_id=?";
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
								sql = "update list set list_id=? where list_id=?";
								ps = conn.prepareStatement(sql);
								ps.setString(1, session.getAttribute("startarray").toString());
								ps.setString(2, session.getAttribute("lastarray").toString());
								
								result = ps.executeUpdate();
								
							}catch(Exception e){
								e.printStackTrace();
							}finally{
							}
							
							try{
								sql = "update list set list_id=? where list_id='0'";
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
				ConnUtil.close(rs, ps, conn);
			}
		}
	}
	
	//out.write(ja.toString());
		
%>