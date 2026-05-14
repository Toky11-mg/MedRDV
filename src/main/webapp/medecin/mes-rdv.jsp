<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Medecin, mg.itu.model.RDV, mg.itu.dao.RDVDAO, java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter, java.time.LocalDateTime" %>
<%!
    // Formater la date : 2026-04-17 08:00:00.0 → "17/04/2026 à 08h00"
    private String formatDate(java.sql.Timestamp ts) {
        if (ts == null) return "—";
        LocalDateTime ldt = ts.toLocalDateTime();
        return DateTimeFormatter.ofPattern("dd/MM/yyyy 'à' HH'h'mm").format(ldt);
    }
%>
<%
    Medecin medecin = (Medecin) session.getAttribute("medecin");
    if (medecin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    RDVDAO rdvDAO    = new RDVDAO();
    List<RDV> mesRdv = rdvDAO.findByMedecin(medecin.getIdmed());

    // Stats
    long nbConfirmes = mesRdv.stream().filter(r -> "CONFIRME".equals(r.getStatut())).count();
    long nbAnnules   = mesRdv.stream().filter(r -> "ANNULE".equals(r.getStatut())).count();

    String filtre = request.getParameter("filtre"); // CONFIRME / ANNULE / null = tous
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mes Rendez-vous — Médecin</title>
  <link rel="stylesheet" href="../css/styles.css">
  <style>
    .stats { display:flex; gap:20px; margin-bottom:24px; }
    .stat-card { background:white; border-radius:10px; padding:20px 28px;
                 box-shadow:0 2px 10px rgba(0,0,0,.08); text-align:center; flex:1; }
    .stat-card .nb    { font-size:2em; font-weight:bold; color:#27ae60; }
    .stat-card .label { color:#666; margin-top:4px; }

    .badge-confirme { background:#eafaf1; color:#27ae60; padding:4px 12px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }
    .badge-annule   { background:#fdecea; color:#e74c3c; padding:4px 12px;
                      border-radius:20px; font-size:.85em; font-weight:bold; }

    .filtres { display:flex; gap:10px; margin-bottom:20px; }
    .filtre-btn { padding:8px 20px; border-radius:20px; border:2px solid #27ae60;
                  background:white; color:#27ae60; cursor:pointer;
                  text-decoration:none; font-weight:bold; font-size:.9em; }
    .filtre-btn.actif { background:#27ae60; color:white; }

    .search-box { background:white; padding:16px 20px; border-radius:10px;
                  box-shadow:0 2px 10px rgba(0,0,0,.08);
                  margin-bottom:20px; display:flex; gap:10px; }
    .search-box input { flex:1; padding:10px; border:1px solid #ddd;
                        border-radius:6px; font-size:1em; }
    .search-box button { padding:10px 20px; background:#27ae60; color:white;
                         border:none; border-radius:6px; cursor:pointer;
                         font-weight:bold; }
  </style>
</head>
<body>

<div class="navbar">
  <span>🏥 MedRDV — Espace Médecin</span>
  <div>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="horaires.jsp">🕐 Mes horaires</a>
    <a href="top5.jsp">🏆 Top 5</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">
  <h2 style="margin-bottom:20px">📅 Mes Rendez-vous</h2>

  <!-- Stats -->
  <div class="stats">
    <div class="stat-card">
      <div class="nb" style="color:#2c7be5"><%= mesRdv.size() %></div>
      <div class="label">Total RDV</div>
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

  <!-- Recherche par nom patient -->
  <form method="get" class="search-box">
    <input type="text" name="search"
           placeholder="🔍 Rechercher un patient par nom..."
           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    <input type="hidden" name="filtre" value="<%= filtre != null ? filtre : "" %>">
    <button type="submit">Rechercher</button>
  </form>

  <!-- Filtres -->
  <div class="filtres">
    <a href="mes-rdv.jsp"
       class="filtre-btn <%= filtre == null ? "actif" : "" %>">
      Tous
    </a>
    <a href="mes-rdv.jsp?filtre=CONFIRME"
       class="filtre-btn <%= "CONFIRME".equals(filtre) ? "actif" : "" %>">
      ✅ Confirmés
    </a>
    <a href="mes-rdv.jsp?filtre=ANNULE"
       class="filtre-btn <%= "ANNULE".equals(filtre) ? "actif" : "" %>">
      ❌ Annulés
    </a>
  </div>

  <!-- Message annulation -->
  <% if ("1".equals(request.getParameter("annule"))) { %>
    <p class="succes" style="margin-bottom:16px">
      ✅ Rendez-vous annulé avec succès.
    </p>
  <% } %>

  <!-- Tableau RDV -->
  <%
    String search = request.getParameter("search");
    boolean hasSearch = search != null && !search.trim().isEmpty();
    int count = 0;
  %>
  <% if (mesRdv.isEmpty()) { %>
    <div style="text-align:center; padding:60px 0; color:#666">
      <p style="font-size:1.2em">Aucun rendez-vous pour le moment.</p>
    </div>
  <% } else { %>
    <table>
      <tr>
        <th>Date & Heure</th>
        <th>Patient</th>
        <th>Statut</th>
        <th>Action</th>
      </tr>
      <% for (RDV r : mesRdv) {
             // Filtre par statut
             if (filtre != null && !filtre.isEmpty() && !filtre.equals(r.getStatut())) continue;
             // Filtre par nom patient
             if (hasSearch && !r.getNom_pat().toLowerCase().contains(search.toLowerCase())) continue;
             count++;
      %>
      <tr>
        <td><strong><%= formatDate(r.getDate_rdv()) %></strong></td>
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
               onclick="return confirm('Annuler ce RDV avec <%= r.getNom_pat() %> ?')">
              Annuler
            </a>
          <% } else { %>
            <span style="color:#aaa; font-size:.9em">—</span>
          <% } %>
        </td>
      </tr>
      <% } %>

      <!-- Aucun résultat après filtre -->
      <% if (count == 0) { %>
      <tr>
        <td colspan="4" style="text-align:center; color:#666; padding:30px">
          Aucun rendez-vous trouvé pour ce filtre.
        </td>
      </tr>
      <% } %>
    </table>

    <p style="margin-top:12px; color:#666; font-size:.9em">
      <%= count %> rendez-vous affiché(s)
    </p>
  <% } %>
</div>

</body>
</html>