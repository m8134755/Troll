<%@ page import="org.json.simple.*" %>
<%@ page import="util.ConnUtil" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	response.setContentType("application/json");
	String userid = request.getParameter("userid");
	String password = request.getParameter("password");
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject json = new JSONObject();
	
	try{
		conn = ConnUtil.getConnection();
		String sql = "select * from user where user_id=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userid);
		rs = ps.executeQuery();
		if(rs.next()){
			String DBpw = rs.getString("password");
			
			if(!DBpw.equals(password)){
				json.put("status", 0);
				throw new Exception("password invalidate");
			}
			
			json.put("status", 1);
			session.setAttribute("userid", userid);
			session.setAttribute("name", rs.getString("name"));
			session.setMaxInactiveInterval(60 * 60);
		}
		else{
			json.put("status", 0);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		ConnUtil.close(rs, ps, conn);
	}
	
	
	out.write(json.toString());
	
	
%>