<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.*, mg.itu.dao.*, mg.itu.util.MailUtil" %>
<%
    Medecin medecin = (Medecin) session.getAttribute("medecin");
    if (medecin == null) { response.sendRedirect("login.jsp"); return; }

    String idrdv = request.getParameter("idrdv");
    RDVDAO dao   = new RDVDAO();
    RDV rdv      = dao.annuler(idrdv);

    if (rdv != null) {
        // Récupérer l'email du patient pour lui envoyer le mail
        PatientDAO patDAO = new PatientDAO();
        Patient pat = patDAO.findById(rdv.getIdpat());
        if (pat != null) {
            MailUtil.sendAnnulation(
                pat.getEmail(),
                pat.getNom_pat(),
                medecin.getNommed(),
                rdv.getDate_rdv().toString()
            );
        }
    }
    response.sendRedirect("dashboard.jsp?annule=1");
%>