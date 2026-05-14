<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.*, mg.itu.dao.*, java.util.*" %>
<%
    Medecin medecin = (Medecin) session.getAttribute("medecin");
    if (medecin == null) { response.sendRedirect("login.jsp"); return; }

    RDVDAO rdvDAO = new RDVDAO();
    List<RDV> mesRdv = rdvDAO.findByMedecin(medecin.getIdmed());

    // Compter les stats
    long nbConfirmes = mesRdv.stream().filter(r -> "CONFIRME".equals(r.getStatut())).count();
    long nbAnnules   = mesRdv.stream().filter(r -> "ANNULE".equals(r.getStatut())).count();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard Médecin</title>
  <link rel="stylesheet" href="../css/styles.css">
  <style>
    .stats { display:flex; gap:20px; margin-bottom:30px; }
    .stat-card { background:white; border-radius:10px; padding:24px 32px;
                 box-shadow:0 2px 10px rgba(0,0,0,.08); text-align:center; flex:1; }
    .stat-card .nb { font-size:2.5em; font-weight:bold; color:#2c7be5; }
    .stat-card .label { color:#666; margin-top:4px; }
    .badge-confirme { background:#eafaf1; color:#27ae60; padding:4px 10px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }
    .badge-annule   { background:#fdecea; color:#e74c3c; padding:4px 10px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }
  </style>
</head>
<body>

<div class="navbar">
  <span>🏥 MedRDV — Espace Médecin</span>
  <div>
    <span style="margin-right:16px">Dr. <%= medecin.getNommed() %></span>
    <a href="mes-rdv.jsp">📅 Mes RDV</a>
    <a href="mon-profil.jsp">👤 Mon profil</a>
    <a href="horaires.jsp">🕐 Mes horaires</a>
    <a href="top5.jsp">🏆 Top 5</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">

  <!-- Infos médecin -->
  <div style="background:white; padding:20px 28px; border-radius:10px;
              box-shadow:0 2px 10px rgba(0,0,0,.08); margin-bottom:24px;
              display:flex; justify-content:space-between; align-items:center">
    <div>
      <h2>Bonjour, Dr. <%= medecin.getNommed() %> 👋</h2>
      <p style="color:#666; margin-top:4px">
        <%= medecin.getSpecialite() %> —
        <%= medecin.getLieu() %> —
        <%= medecin.getTaux_horaire() %> Ar/h
      </p>
    </div>
    <a href="mon-profil.jsp" class="btn btn-medecin" style="padding:10px 20px">
      ✏️ Modifier mon profil
    </a>
  </div>

  <!-- Stats -->
  <div class="stats">
    <div class="stat-card">
      <div class="nb"><%= mesRdv.size() %></div>
      <div class="label">Total RDV</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:#27ae60"><%= nbConfirmes %></div>
      <div class="label">RDV Confirmés</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:#e74c3c"><%= nbAnnules %></div>
      <div class="label">RDV Annulés</div>
    </div>
  </div>

  <!-- Prochains RDV -->
  <h3 style="margin-bottom:16px">📅 Mes rendez-vous</h3>
  <% if (mesRdv.isEmpty()) { %>
    <p>Aucun rendez-vous pour le moment.</p>
  <% } else { %>
  <table>
    <tr>
      <th>Date & Heure</th>
      <th>Patient</th>
      <th>Statut</th>
      <th>Action</th>
    </tr>
    <% for (RDV r : mesRdv) { %>
    <tr>
      <td><%= r.getDate_rdv() %></td>
      <td><%= r.getNom_pat() %></td>
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
             onclick="return confirm('Annuler ce RDV ?')">Annuler</a>
        <% } %>
      </td>
    </tr>
    <% } %>
  </table>
  <% } %>
</div>
</body>
</html>