<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="util.ConnUtil" %>
<%@ page import="java.sql.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.PasswordAuthentication" %>
<%@ page import="mail.SMTPAuthenticator"%>
<%@page import="java.util.Random"%>
<%@page import="org.apache.http.impl.client.cache.memcached.SHA256KeyHashingScheme"%>

<%
   response.setHeader ( "Cache-Control", "no-cache,no-store,must-revalidate" ) ;
   response.setHeader ( "Pragma", "no-cache" ) ;
   response.setDateHeader ( "Expires", 0 ) ;
   request.setCharacterEncoding("UTF-8");
   response.setCharacterEncoding("UTF-8");
   response.setContentType("application/json");
   String id = request.getParameter("userid").toString();
   String username = request.getParameter("username").toString();
   String email = request.getParameter("useremail").toString();
   
   String sender = "kdh7785@naver.com";
   String receiver = email;
   String subject = "트롤 Troll 비밀번호찾기";
   String content = "트롤 Troll에서 보낸 메일 입니다.\n";
   
   
   Connection conn = null;
   PreparedStatement ps = null;
   ResultSet rs = null;
   
   JSONObject json = new JSONObject();
   
   char[][] letter = {{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'},
			{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'},
			{'0','1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0','1','2','3','4','5'}};
   
   Properties props = new Properties ( ) ;
   props.put ("mail.smtp.user","kdh7785@naver.com");
   props.put ("mail.smtp.host" , "smtp.naver.com" );
   props.put ("mail.smtp.starttls.enable", "true");
   props.put ("mail.smtp.auth", "true");
   props.put ("mail.smtp.debug", "true");
   props.put ("mail.smtp.port", "465");
   props.put ("mail.smtp.socketFactory.port", "465");
   props.setProperty ("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
   props.put ("mail.smtp.socketFactory.fallback", "false");
   
   try{
      conn = ConnUtil.getConnection();
      String sql = "select * from user where user_id = ? and name = ? and email = ? ;";
      ps = conn.prepareStatement(sql);
      ps.setString(1, id);
      ps.setString(2, username);
      ps.setString(3, email);
      
      rs = ps.executeQuery();
      if(rs.next()){
         
			String[] namelist = {username};
			Random random = new Random();
			
			String newpassword = "";
			
			for(int i=0; i<8; i++){
				int lettercase = random.nextInt(3);
				int letternum = random.nextInt(26);
				newpassword += letter[lettercase][letternum];
			}
			
			String hashpw = new SHA256KeyHashingScheme().hash(newpassword);
			
			sql = "update user set password = ? where user_id = ?;";
			ps = conn.prepareStatement(sql);
			ps.setString(1, hashpw);
			ps.setString(2, id);
			
			ps.executeUpdate();
			conn.setAutoCommit(false);
			conn.commit();
			
            content += "\n" + username;
            content += "님의 임시비밀번호는 ";
            content += newpassword;
            content += " 입니다.\n";
         try {
            
            Authenticator auth = new SMTPAuthenticator();
            Session ses = Session.getInstance(props,auth);
            
            ses.setDebug(true);
            
            MimeMessage msg = new MimeMessage(ses);
            
            msg.setSubject(subject);
            
            Address fromAddr = new InternetAddress(sender);
            msg.setFrom(fromAddr);
            
            Address toAddr = new InternetAddress(receiver);
            msg.addRecipient(Message.RecipientType.TO, toAddr);
            
            msg.setContent(content, "text/html;charset=UTF-8");
            
            Transport.send(msg);
            

            
         } catch ( Exception e ) {
            e.printStackTrace();
            String script = "<script type = 'text/javascripst'>\n";
            script += "alert('메일발송에 실패했습니다.');\n";
            script += "history.back();\n";
            script += "</script>";
            out.println(script);
            return;
         } finally { }
         json.put("status", 1);
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