<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.*, mg.itu.dao.*, mg.itu.util.MailUtil" %>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) { response.sendRedirect("login.jsp"); return; }

    String idrdv = request.getParameter("idrdv");
    RDVDAO dao   = new RDVDAO();
    RDV rdv      = dao.annuler(idrdv);

    if (rdv != null) {
        MailUtil.sendAnnulation(
            patient.getEmail(),
            patient.getNom_pat(),
            rdv.getNommed(),
            rdv.getDate_rdv().toString()
        );
    }
    response.sendRedirect("dashboard.jsp?annule=1");
%>