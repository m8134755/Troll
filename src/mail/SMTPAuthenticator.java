package mail;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticator extends javax.mail.Authenticator
{
   public PasswordAuthentication getPasswordAuthentication()
   {
      return new PasswordAuthentication("kdh7785", "h3281011~");
   }
}