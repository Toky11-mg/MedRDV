package mg.itu.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class MailUtil {

    // ⚠️ Remplace par tes vraies infos Gmail
    private static final String FROM     = "itokiniainar@gmail.com";
    private static final String PASSWORD = "jyaaesgvgmmqtvck"; 

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host",            "smtp.gmail.com");
        props.put("mail.smtp.port",            "587");
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
             @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM, PASSWORD);
            }
        });
    }

    // ── Mail de CONFIRMATION ───────────────────────────────
    public static void sendConfirmation(String toEmail, String nomPatient,
                                        String nomMedecin, String dateRdv) {
        try {
            Message msg = new MimeMessage(getSession());
            msg.setFrom(new InternetAddress(FROM));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("✅ Confirmation de votre rendez-vous médical");
            msg.setText(
                "Bonjour " + nomPatient + ",\n\n" +
                "Votre rendez-vous avec Dr. " + nomMedecin +
                " est confirmé pour le : " + dateRdv + "\n\n" +
                "Merci de vous présenter 10 minutes avant l'heure.\n\n" +
                "MedRDV - Gestion de rendez-vous médicaux"
            );
            Transport.send(msg);
        } catch (MessagingException e) {
            System.err.println("Erreur envoi mail confirmation : " + e.getMessage());
        }
    }

    // ── Mail d'ANNULATION ─────────────────────────────────
    public static void sendAnnulation(String toEmail, String nomPatient,
                                      String nomMedecin, String dateRdv) {
        try {
            Message msg = new MimeMessage(getSession());
            msg.setFrom(new InternetAddress(FROM));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("❌ Annulation de votre rendez-vous médical");
            msg.setText(
                "Bonjour " + nomPatient + ",\n\n" +
                "Votre rendez-vous avec Dr. " + nomMedecin +
                " prévu le " + dateRdv + " a été annulé.\n\n" +
                "Vous pouvez reprendre un nouveau rendez-vous sur notre plateforme.\n\n" +
                "MedRDV - Gestion de rendez-vous médicaux"
            );
            Transport.send(msg);
        } catch (MessagingException e) {
            System.err.println("Erreur envoi mail annulation : " + e.getMessage());
        }
    }
}