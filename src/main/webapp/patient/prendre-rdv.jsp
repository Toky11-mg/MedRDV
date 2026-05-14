<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.*, mg.itu.dao.*, mg.itu.util.MailUtil, java.util.*, java.sql.*" %>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) { response.sendRedirect("login.jsp"); return; }

    String idmed   = request.getParameter("idmed");
    Medecin medecin = new MedecinDAO().findById(idmed);
    RDVDAO rdvDAO  = new RDVDAO();
    String message = null;
    String erreur  = null;

    if ("POST".equals(request.getMethod())) {
        String dateChoisie = request.getParameter("creneau");
        if (dateChoisie != null && !dateChoisie.isEmpty()) {
            RDV rdv = new RDV();
            rdv.setIdrdv   ("RDV" + System.currentTimeMillis());
            rdv.setIdmed   (idmed);
            rdv.setIdpat   (patient.getIdpat());
            rdv.setStatut  ("CONFIRME");
            try {
                rdv.setDate_rdv(Timestamp.valueOf(dateChoisie + ":00"));
                boolean ok = rdvDAO.create(rdv);
                if (ok) {
                    MailUtil.sendConfirmation(
                        patient.getEmail(), patient.getNom_pat(),
                        medecin.getNommed(), dateChoisie
                    );
                    message = "RDV confirmé le " + dateChoisie + " avec Dr. " + medecin.getNommed();
                } else {
                    erreur = "Ce créneau vient d'être pris. Choisissez un autre.";
                }
            } catch (Exception e) {
                erreur = "Erreur lors de la réservation : " + e.getMessage();
            }
        }
    }

    String dateSelectionnee = request.getParameter("date");
    if (dateSelectionnee == null) dateSelectionnee = "";
    List<String> creneaux = new ArrayList<>();
    if (!dateSelectionnee.isEmpty()) {
        creneaux = rdvDAO.getCreneauxDisponibles(idmed, dateSelectionnee);
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Prendre RDV — MedRDV</title>
  <link rel="stylesheet" href="../css/styles.css?v=2">
  <style>
    .rdv-wrapper {
      max-width: 680px;
      margin: 0 auto;
    }

    /* Card médecin info */
    .medecin-card {
      background: linear-gradient(135deg, var(--dark), var(--dark-blue));
      border-radius: var(--radius-lg);
      padding: 28px 32px;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 20px;
      position: relative;
      overflow: hidden;
    }

    .medecin-card::before {
      content: '';
      position: absolute;
      right: -30px; top: -30px;
      width: 120px; height: 120px;
      border-radius: 50%;
      background: rgba(233,69,96,.1);
    }

    .medecin-avatar {
      width: 64px; height: 64px;
      border-radius: 50%;
      background: rgba(233,69,96,.2);
      border: 3px solid rgba(233,69,96,.4);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.6em;
      flex-shrink: 0;
    }

    .medecin-info h2 {
      color: var(--white);
      font-size: 1.2em;
      font-weight: 700;
      margin-bottom: 4px;
    }

    .medecin-info p {
      color: rgba(255,255,255,.6);
      font-size: .85em;
      margin-bottom: 0;
    }

    .medecin-tags {
      display: flex;
      gap: 8px;
      margin-top: 8px;
      flex-wrap: wrap;
    }

    .medecin-tag {
      background: rgba(255,255,255,.08);
      border: 1px solid rgba(255,255,255,.15);
      color: rgba(255,255,255,.75);
      padding: 4px 12px;
      border-radius: var(--radius-full);
      font-size: .75em;
      font-weight: 600;
    }

    .medecin-tag.accent {
      background: rgba(233,69,96,.2);
      border-color: rgba(233,69,96,.3);
      color: #ff8a9b;
    }

    /* Date picker card */
    .date-card {
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 24px 28px;
      margin-bottom: 20px;
      box-shadow: var(--shadow-sm);
    }

    .date-card h3 {
      font-size: .88em;
      font-weight: 700;
      color: var(--gray-600);
      text-transform: uppercase;
      letter-spacing: .6px;
      margin-bottom: 14px;
    }

    .date-picker-row {
      display: flex;
      gap: 12px;
      align-items: center;
    }

    .date-picker-row input[type="date"] {
      flex: 1;
      padding: 12px 16px;
      border: 2px solid var(--gray-200);
      border-radius: var(--radius-md);
      font-size: .95em;
      font-family: inherit;
      color: var(--dark);
      background: var(--gray-50);
      transition: all .2s;
    }

    .date-picker-row input[type="date"]:focus {
      outline: none;
      border-color: var(--accent);
      box-shadow: 0 0 0 4px rgba(233,69,96,.1);
    }

    .date-picker-row button {
      padding: 12px 24px;
      background: linear-gradient(135deg, var(--dark), var(--dark-blue));
      color: white;
      border: none;
      border-radius: var(--radius-md);
      font-weight: 700;
      font-family: inherit;
      font-size: .9em;
      cursor: pointer;
      transition: all .2s;
      white-space: nowrap;
    }

    .date-picker-row button:hover {
      opacity: .88;
      transform: translateY(-1px);
    }

    /* Créneaux */
    .creneaux-card {
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 24px 28px;
      margin-bottom: 20px;
      box-shadow: var(--shadow-sm);
    }

    .creneaux-card h3 {
      font-size: .88em;
      font-weight: 700;
      color: var(--gray-600);
      text-transform: uppercase;
      letter-spacing: .6px;
      margin-bottom: 18px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .creneaux-card h3 span {
      background: var(--success-light);
      color: var(--success);
      padding: 3px 10px;
      border-radius: var(--radius-full);
      font-size: .85em;
    }

    .creneau-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 24px;
    }

    .creneau-label { cursor: pointer; }
    .creneau-label input[type="radio"] { display: none; }

    .creneau-slot {
      padding: 12px 20px;
      background: var(--success-light);
      border: 2px solid rgba(15,154,114,.25);
      border-radius: var(--radius-md);
      color: var(--success);
      font-weight: 700;
      font-size: .92em;
      font-family: inherit;
      transition: all .2s;
      display: block;
      text-align: center;
      min-width: 90px;
    }

    .creneau-slot:hover {
      border-color: var(--success);
      transform: translateY(-3px);
      box-shadow: 0 6px 16px rgba(15,154,114,.2);
    }

    .creneau-label input[type="radio"]:checked + .creneau-slot {
      background: var(--success);
      color: var(--white);
      border-color: var(--success);
      box-shadow: 0 6px 20px rgba(15,154,114,.35);
      transform: translateY(-3px);
    }

    /* Bouton confirmer */
    .btn-confirmer {
      width: 100%;
      padding: 16px;
      background: linear-gradient(135deg, var(--accent), var(--accent-dark));
      color: white;
      border: none;
      border-radius: var(--radius-md);
      font-size: 1em;
      font-weight: 800;
      cursor: pointer;
      font-family: inherit;
      letter-spacing: .3px;
      transition: all .25s;
      box-shadow: 0 4px 15px rgba(233,69,96,.3);
    }

    .btn-confirmer:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(233,69,96,.4);
    }

    /* Message succès stylisé */
    .success-banner {
      background: linear-gradient(135deg, var(--success), #0d7a5a);
      color: white;
      padding: 20px 24px;
      border-radius: var(--radius-md);
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      animation: slideUp .4s ease;
    }

    .success-banner .icon { font-size: 2em; }
    .success-banner h4 { font-size: 1em; font-weight: 700; margin-bottom: 4px; }
    .success-banner p  { font-size: .85em; opacity: .85; }

    .no-creneau {
      text-align: center;
      padding: 40px 20px;
      color: var(--gray-600);
    }

    .no-creneau .icon { font-size: 3em; margin-bottom: 12px; }
    .no-creneau p { font-size: .95em; }
  </style>
</head>
<body>

<div class="navbar">
  <span>🏥 MedRDV</span>
  <div>
    <a href="chercher-medecin.jsp">← Retour recherche</a>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">
  <div class="rdv-wrapper">

    <!-- Card médecin -->
    <div class="medecin-card">
      <div class="medecin-avatar">🩺</div>
      <div class="medecin-info">
        <h2>Dr. <%= medecin.getNommed() %></h2>
        <div class="medecin-tags">
          <span class="medecin-tag accent"><%= medecin.getSpecialite() %></span>
          <span class="medecin-tag">📍 <%= medecin.getLieu() %></span>
          <span class="medecin-tag">💰 <%= medecin.getTaux_horaire() %> Ar/h</span>
        </div>
      </div>
    </div>

    <!-- Messages -->
    <% if (message != null) { %>
      <div class="success-banner">
        <div class="icon">✅</div>
        <div>
          <h4>Rendez-vous confirmé !</h4>
          <p><%= message %> — Un email de confirmation vous a été envoyé.</p>
        </div>
      </div>
      <div style="text-align:center; margin-bottom:20px">
        <a href="mes-rdv.jsp" class="btn btn-patient">📅 Voir mes RDV</a>
      </div>
    <% } %>

    <% if (erreur != null) { %>
      <p class="erreur">❌ <%= erreur %></p>
    <% } %>

    <!-- Choisir une date -->
    <div class="date-card">
      <h3>📆 Choisir une date</h3>
      <form method="get" class="date-picker-row">
        <input type="hidden" name="idmed" value="<%= idmed %>">
        <input type="date" name="date"
               value="<%= dateSelectionnee %>"
               min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
        <button type="submit">Voir les créneaux →</button>
      </form>
    </div>

    <!-- Créneaux disponibles -->
    <% if (!dateSelectionnee.isEmpty()) { %>
      <div class="creneaux-card">
        <h3>
          🕐 Créneaux disponibles
          <% if (!creneaux.isEmpty()) { %>
            <span><%= creneaux.size() %> libre(s)</span>
          <% } %>
        </h3>

        <% if (creneaux.isEmpty()) { %>
          <div class="no-creneau">
            <div class="icon">😔</div>
            <p>Aucun créneau disponible pour cette date.</p>
            <p style="font-size:.85em; margin-top:8px; color:var(--gray-400)">
              Essayez une autre date.
            </p>
          </div>
        <% } else { %>
          <form method="post">
            <input type="hidden" name="idmed" value="<%= idmed %>">
            <div class="creneau-grid">
              <% for (String c : creneaux) { %>
              <label class="creneau-label">
                <input type="radio" name="creneau" value="<%= c %>" required>
                <span class="creneau-slot"><%= c.substring(11) %></span>
              </label>
              <% } %>
            </div>
            <button type="submit" class="btn-confirmer">
              ✅ Confirmer le rendez-vous
            </button>
          </form>
        <% } %>
      </div>
    <% } %>

  </div>
</div>

</body>
</html>