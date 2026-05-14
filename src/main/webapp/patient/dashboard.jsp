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

    // Prochain RDV confirmé
    RDV prochain = mesRdv.stream()
        .filter(r -> "CONFIRME".equals(r.getStatut()))
        .findFirst().orElse(null);
%>
<%!
    private String formatDate(java.sql.Timestamp ts) {
        if (ts == null) return "—";
        LocalDateTime ldt = ts.toLocalDateTime();
        return DateTimeFormatter.ofPattern("dd/MM/yyyy 'à' HH'h'mm").format(ldt);
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — MedRDV</title>
  <link rel="stylesheet" href="../css/styles.css?v=2">
  <style>
    /* Bannière de bienvenue */
    .welcome-banner {
      background: linear-gradient(135deg, var(--dark) 0%, var(--dark-blue) 100%);
      border-radius: var(--radius-lg);
      padding: 28px 32px;
      margin-bottom: 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
      overflow: hidden;
    }

    .welcome-banner::before {
      content: '';
      position: absolute;
      right: -40px; top: -40px;
      width: 160px; height: 160px;
      border-radius: 50%;
      background: rgba(233,69,96,.08);
    }

    .welcome-banner::after {
      content: '';
      position: absolute;
      right: 60px; bottom: -30px;
      width: 100px; height: 100px;
      border-radius: 50%;
      background: rgba(255,255,255,.04);
    }

    .welcome-text h2 {
      color: var(--white);
      font-size: 1.4em;
      font-weight: 800;
      margin-bottom: 6px;
    }

    .welcome-text h2 span { color: var(--accent); }

    .welcome-text p {
      color: rgba(255,255,255,.55);
      font-size: .88em;
      margin-bottom: 0;
    }

    .welcome-actions {
      display: flex;
      gap: 10px;
      position: relative;
      z-index: 1;
      flex-shrink: 0;
    }

    /* Prochain RDV */
    .prochain-card {
      background: linear-gradient(135deg, var(--accent), var(--accent-dark));
      border-radius: var(--radius-md);
      padding: 20px 24px;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 16px;
      animation: slideUp .4s ease;
    }

    .prochain-card .icon-wrap {
      width: 52px; height: 52px;
      background: rgba(255,255,255,.15);
      border-radius: var(--radius-md);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.6em;
      flex-shrink: 0;
    }

    .prochain-card .info h4 {
      color: white;
      font-size: 1em;
      font-weight: 700;
      margin-bottom: 4px;
    }

    .prochain-card .info p {
      color: rgba(255,255,255,.75);
      font-size: .85em;
      margin-bottom: 0;
    }

    .prochain-card .btn-annuler {
      margin-left: auto;
      background: rgba(255,255,255,.15);
      border: 1px solid rgba(255,255,255,.25);
      color: white;
      padding: 8px 16px;
      border-radius: var(--radius-sm);
      font-size: .82em;
      font-weight: 700;
      cursor: pointer;
      font-family: inherit;
      transition: all .2s;
      text-decoration: none;
      flex-shrink: 0;
    }

    .prochain-card .btn-annuler:hover {
      background: rgba(255,255,255,.25);
    }

    /* Stats */
    .stats { display: flex; gap: 18px; margin-bottom: 28px; }

    .stat-card {
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 22px 26px;
      box-shadow: var(--shadow-sm);
      text-align: center;
      flex: 1;
      border-bottom: 3px solid var(--accent);
      position: relative;
      overflow: hidden;
      transition: all .25s;
      cursor: default;
    }

    .stat-card:nth-child(2) { border-color: var(--success); }
    .stat-card:nth-child(3) { border-color: #4361ee; }

    .stat-card::before {
      content: '';
      position: absolute;
      top: -20px; right: -20px;
      width: 70px; height: 70px;
      border-radius: 50%;
      background: rgba(233,69,96,.05);
      transition: all .3s;
    }

    .stat-card:nth-child(2)::before { background: rgba(15,154,114,.05); }
    .stat-card:nth-child(3)::before { background: rgba(67,97,238,.05); }

    .stat-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
    .stat-card:hover::before { width: 100px; height: 100px; }

    .stat-card .nb    { font-size: 2.4em; font-weight: 800; color: var(--dark); line-height: 1; }
    .stat-card .label { color: var(--gray-600); margin-top: 6px; font-size: .78em; font-weight: 600; text-transform: uppercase; letter-spacing: .5px; }

    /* Section titre */
    .section-title {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
    }

    .section-title h3 {
      font-size: 1em;
      font-weight: 700;
      color: var(--dark);
      text-transform: uppercase;
      letter-spacing: .5px;
    }

    .section-title a {
      font-size: .85em;
      color: var(--accent);
      font-weight: 600;
      text-decoration: none;
    }

    .section-title a:hover { text-decoration: underline; }

    /* Empty state */
    .empty-state {
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 48px 20px;
      text-align: center;
      box-shadow: var(--shadow-sm);
      border: 2px dashed var(--gray-200);
    }

    .empty-state .icon { font-size: 3em; margin-bottom: 16px; }
    .empty-state p { color: var(--gray-600); font-size: .95em; margin-bottom: 20px; }
  </style>
</head>
<body>

<div class="navbar">
  <span>🏥 MedRDV — Espace Patient</span>
  <div>
    <span style="color:rgba(255,255,255,.6); font-size:.88em; margin-right:8px">
      👤 <%= patient.getNom_pat() %>
    </span>
    <a href="chercher-medecin.jsp">🔍 Chercher</a>
    <a href="mes-rdv.jsp">📅 Mes RDV</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">

  <!-- Bienvenue -->
  <div class="welcome-banner">
    <div class="welcome-text">
      <h2>Bonjour, <span><%= patient.getNom_pat() %></span> 👋</h2>
      <p>Gérez vos rendez-vous médicaux facilement depuis votre espace personnel.</p>
    </div>
    <div class="welcome-actions">
      <a href="chercher-medecin.jsp" class="btn btn-patient"
         style="padding:10px 20px; font-size:.88em">
        ➕ Nouveau RDV
      </a>
      <a href="mes-rdv.jsp" class="btn"
         style="padding:10px 20px; font-size:.88em;
                background:rgba(255,255,255,.1);
                border:1px solid rgba(255,255,255,.2)">
        📅 Mes RDV
      </a>
    </div>
  </div>

  <!-- Prochain RDV -->
  <% if (prochain != null) { %>
  <div class="prochain-card">
    <div class="icon-wrap">📅</div>
    <div class="info">
      <h4>Prochain rendez-vous</h4>
      <p>
        Dr. <%= prochain.getNommed() %> —
        <%= prochain.getSpecialite() %> —
        <strong style="color:white"><%= formatDate(prochain.getDate_rdv()) %></strong>
      </p>
    </div>
    <a href="annuler-rdv.jsp?idrdv=<%= prochain.getIdrdv() %>"
       class="btn-annuler"
       onclick="return confirm('Annuler ce RDV ?')">
      Annuler
    </a>
  </div>
  <% } %>

  <!-- Stats -->
  <div class="stats">
    <div class="stat-card">
      <div class="nb" id="cntTotal"><%= mesRdv.size() %></div>
      <div class="label">Total RDV</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:var(--success)"
           id="cntConfirme"><%= nbConfirmes %></div>
      <div class="label">Confirmés</div>
    </div>
    <div class="stat-card">
      <div class="nb" style="color:var(--accent)"
           id="cntAnnule"><%= nbAnnules %></div>
      <div class="label">Annulés</div>
    </div>
  </div>

  <!-- Tableau des RDV récents -->
  <div class="section-title">
    <h3>📋 Mes derniers rendez-vous</h3>
    <a href="mes-rdv.jsp">Voir tous →</a>
  </div>

  <% if (mesRdv.isEmpty()) { %>
    <div class="empty-state">
      <div class="icon">🗓️</div>
      <p>Vous n'avez aucun rendez-vous pour le moment.</p>
      <a href="chercher-medecin.jsp" class="btn btn-patient">
        📅 Prendre mon premier RDV
      </a>
    </div>
  <% } else { %>
    <table>
      <thead>
        <tr>
          <th>Date & Heure</th>
          <th>Médecin</th>
          <th>Spécialité</th>
          <th>Statut</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <%
          int count = 0;
          for (RDV r : mesRdv) {
            if (count++ >= 5) break; // Afficher les 5 derniers
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
                 onclick="return confirm('Annuler ce RDV ?')">
                Annuler
              </a>
            <% } else { %>
              <span style="color:var(--gray-400)">—</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>

    <% if (mesRdv.size() > 5) { %>
      <div style="text-align:center; margin-top:16px">
        <a href="mes-rdv.jsp" style="color:var(--accent); font-weight:700;
           font-size:.9em; text-decoration:none">
          Voir les <%= mesRdv.size() - 5 %> autres rendez-vous →
        </a>
      </div>
    <% } %>
  <% } %>

</div>

<script>
  // Animation des compteurs
  function animCount(el, target) {
    if (!el) return;
    let current = 0;
    const step  = Math.max(1, Math.ceil(target / 30));
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current;
      if (current >= target) clearInterval(timer);
    }, 40);
  }

  const total    = parseInt('<%= mesRdv.size() %>');
  const confirme = parseInt('<%= nbConfirmes %>');
  const annule   = parseInt('<%= nbAnnules %>');

  animCount(document.getElementById('cntTotal'),   total);
  animCount(document.getElementById('cntConfirme'), confirme);
  animCount(document.getElementById('cntAnnule'),  annule);
</script>

</body>
</html>