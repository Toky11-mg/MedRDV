<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Medecin, mg.itu.dao.RDVDAO, java.util.List" %>
<%
    Medecin medecin = (Medecin) session.getAttribute("medecin");
    if (medecin == null) { response.sendRedirect("login.jsp"); return; }

    String date = request.getParameter("date");
    List<String> creneaux = null;
    if (date != null && !date.isEmpty()) {
        creneaux = new RDVDAO().getCreneauxDisponibles(medecin.getIdmed(), date);
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mes Horaires</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="navbar">
  <span>🏥 MedRDV</span>
  <div>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container" style="max-width:700px">
  <h2 style="margin-bottom:20px">🕐 Mes créneaux disponibles</h2>

  <form method="get" style="display:flex; gap:10px; margin-bottom:30px">
    <input type="date" name="date" value="<%= date != null ? date : "" %>"
           style="padding:10px; border:1px solid #ddd; border-radius:6px; flex:1">
    <button type="submit" class="btn btn-medecin" style="padding:10px 24px">
      Voir disponibilités
    </button>
  </form>

  <% if (creneaux != null) { %>
    <h3 style="margin-bottom:16px">
      Créneaux du <%= date %> :
    </h3>
    <% if (creneaux.isEmpty()) { %>
      <p class="erreur">Aucun créneau disponible — journée complète !</p>
    <% } else { %>
      <div style="display:flex; flex-wrap:wrap; gap:12px">
        <% for (String c : creneaux) { %>
          <div style="background:#eafaf1; border:2px solid #27ae60; border-radius:8px;
                      padding:12px 20px; font-weight:bold; color:#27ae60; font-size:1.1em">
            ✅ <%= c.substring(11) %>
          </div>
        <% } %>
      </div>
      <p style="margin-top:20px; color:#666">
        <%= creneaux.size() %> créneau(x) libre(s) sur 10
      </p>
    <% } %>
  <% } %>
</div>
</body>
</html>