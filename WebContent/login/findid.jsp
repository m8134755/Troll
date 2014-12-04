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
<%
   response.setHeader ( "Cache-Control", "no-cache,no-store,must-revalidate" ) ;
   response.setHeader ( "Pragma", "no-cache" ) ;
   response.setDateHeader ( "Expires", 0 ) ;
   request.setCharacterEncoding("UTF-8");
   response.setCharacterEncoding("UTF-8");
   response.setContentType("application/json");
   String username = request.getParameter("username").toString();
   String email = request.getParameter("useremail").toString();
   
   String sender = "kdh7785@naver.com";
   String receiver = email;
   String subject = "트롤 Troll 아이디찾기";
   String content = "트롤 Troll에서 보낸 메일 입니다.\n";
   
   
   Connection conn = null;
   PreparedStatement ps = null;
   ResultSet rs = null;
   
   JSONObject json = new JSONObject();
   
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
      String sql = "select * from user where name = ? and email = ? ;";
      ps = conn.prepareStatement(sql);
      ps.setString(1, username);
      ps.setString(2, email);
      
      rs = ps.executeQuery();
      if(rs.next()){
         
         content += username;
         content += "님의 아이디는 ";
         content += rs.getString("user_id");
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