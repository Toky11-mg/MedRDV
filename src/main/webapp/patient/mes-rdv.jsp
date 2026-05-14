<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Patient, mg.itu.model.RDV, mg.itu.dao.RDVDAO, java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter, java.time.LocalDateTime" %>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    RDVDAO rdvDAO    = new RDVDAO();
    List<RDV> mesRdv = rdvDAO.findByPatient(patient.getIdpat());

    long nbConfirmes = mesRdv.stream().filter(r -> "CONFIRME".equals(r.getStatut())).count();
    long nbAnnules   = mesRdv.stream().filter(r -> "ANNULE".equals(r.getStatut())).count();

    String filtre = request.getParameter("filtre");
%>
<%!
    private String formatDate(java.sql.Timestamp ts) {
        if (ts == null) return "—";
        java.time.LocalDateTime ldt = ts.toLocalDateTime();
        return java.time.format.DateTimeFormatter
               .ofPattern("dd/MM/yyyy 'à' HH'h'mm").format(ldt);
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mes Rendez-vous</title>
  <link rel="stylesheet" href="../css/styles.css">
  <style>
    .stats { display:flex; gap:20px; margin-bottom:24px; }
    .stat-card { background:white; border-radius:10px; padding:20px 28px;
                 box-shadow:0 2px 10px rgba(0,0,0,.08); text-align:center; flex:1; }
    .stat-card .nb    { font-size:2em; font-weight:bold; color:#2c7be5; }
    .stat-card .label { color:#666; margin-top:4px; }
    .badge-confirme { background:#eafaf1; color:#27ae60; padding:4px 12px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }
    .badge-annule   { background:#fdecea; color:#e74c3c; padding:4px 12px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }
    .filtres { display:flex; gap:10px; margin-bottom:20px; }
    .filtre-btn { padding:8px 20px; border-radius:20px; border:2px solid #2c7be5;
                  background:white; color:#2c7be5; cursor:pointer;
                  text-decoration:none; font-weight:bold; font-size:.9em; }
    .filtre-btn.actif { background:#2c7be5; color:white; }
  </style>
</head>
<body>

<div class="navbar">
  <span>🏥 MedRDV — Espace Patient</span>
  <div>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="chercher-medecin.jsp">🔍 Chercher un médecin</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">
  <h2 style="margin-bottom:20px">📅 Mes Rendez-vous</h2>

  <!-- Stats -->
  <div class="stats">
    <div class="stat-card">
      <div class="nb"><%= mesRdv.size() %></div>
      <div class="label">Total</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:#27ae60"><%= nbConfirmes %></div>
      <div class="label">Confirmés</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:#e74c3c"><%= nbAnnules %></div>
      <div class="label">Annulés</div>
    </div>
  </div>

  <!-- Filtres -->
  <div class="filtres">
    <a href="mes-rdv.jsp"
       class="filtre-btn <%= filtre == null ? "actif" : "" %>">Tous</a>
    <a href="mes-rdv.jsp?filtre=CONFIRME"
       class="filtre-btn <%= "CONFIRME".equals(filtre) ? "actif" : "" %>">✅ Confirmés</a>
    <a href="mes-rdv.jsp?filtre=ANNULE"
       class="filtre-btn <%= "ANNULE".equals(filtre) ? "actif" : "" %>">❌ Annulés</a>
  </div>

  <!-- Message succès annulation -->
  <% if ("1".equals(request.getParameter("annule"))) { %>
    <p class="succes" style="margin-bottom:16px">✅ Rendez-vous annulé avec succès.</p>
  <% } %>

  <!-- Contenu principal -->
  <% if (mesRdv.isEmpty()) { %>

    <!-- Aucun RDV du tout -->
    <div style="text-align:center; padding:60px 0; color:#666">
      <p style="font-size:1.2em">Vous n'avez aucun rendez-vous.</p>
      <a href="chercher-medecin.jsp" class="btn btn-patient"
         style="margin-top:16px; display:inline-block">📅 Prendre un RDV</a>
    </div>

  <% } else { %>
    <%
        // Compter combien passent le filtre
        long totalApresFiltre = 0;
        for (RDV r : mesRdv) {
            if (filtre == null || filtre.isEmpty() || filtre.equals(r.getStatut())) {
                totalApresFiltre++;
            }
        }
    %>

    <% if (totalApresFiltre == 0) { %>

      <!-- RDV existent mais aucun ne passe le filtre -->
      <div style="text-align:center; padding:40px; background:white;
                  border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.08)">
        <p style="font-size:1.2em; color:#666">
          <% if ("CONFIRME".equals(filtre)) { %>
            Vous n'avez aucun rendez-vous confirmé.
          <% } else if ("ANNULE".equals(filtre)) { %>
            Vous n'avez aucun rendez-vous annulé.
          <% } %>
        </p>
        <% if ("CONFIRME".equals(filtre)) { %>
          <a href="chercher-medecin.jsp" class="btn btn-patient"
             style="margin-top:16px; display:inline-block">
            📅 Prendre un nouveau RDV
          </a>
        <% } %>
        <p style="margin-top:12px">
          <a href="mes-rdv.jsp" style="color:#2c7be5">← Voir tous mes RDV</a>
        </p>
      </div>

    <% } else { %>

      <!-- Tableau des RDV -->
      <table>
        <tr>
          <th>Date & Heure</th>
          <th>Médecin</th>
          <th>Spécialité</th>
          <th>Statut</th>
          <th>Action</th>
        </tr>
        <% for (RDV r : mesRdv) {
               if (filtre != null && !filtre.isEmpty() && !filtre.equals(r.getStatut())) continue;
        %>
        <tr>
          <td><strong><%= formatDate(r.getDate_rdv()) %></strong></td>
          <td>Dr. <%= r.getNommed() %></td>
          <td><%= r.getSpecialite() %></td>
          <td>
            <% if ("CONFIRME".equals(r.getStatut())) { %>
              <span class="badge-confirme">✅ CONFIRMÉ</span>
            <% } else { %>
              <span class="badge-annule">❌ ANNULÉ</span>
            <% } %>
          </td>
          <td>
            <% if ("CONFIRME".equals(r.getStatut())) { %>
              <a href="annuler-rdv.jsp?idrdv=<%= r.getIdrdv() %>"
                 class="btn btn-danger"
                 onclick="return confirm('Voulez-vous vraiment annuler ce RDV ?')">
                Annuler
              </a>
            <% } else { %>
              <span style="color:#aaa; font-size:.9em">—</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </table>

      <p style="margin-top:10px; color:#666; font-size:.9em">
        <%= totalApresFiltre %> rendez-vous affiché(s)
      </p>

      <div style="margin-top:16px; text-align:right">
        <a href="chercher-medecin.jsp" class="btn btn-patient"
           style="padding:10px 24px; display:inline-block">➕ Nouveau RDV</a>
      </div>

    <% } %>
  <% } %>
</div>

</body>
</html>