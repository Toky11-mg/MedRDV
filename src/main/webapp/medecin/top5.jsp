<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Medecin, mg.itu.dao.MedecinDAO, java.util.List" %>
<%
    if (session.getAttribute("medecin") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Medecin> top5 = new MedecinDAO().top5Consultes();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Top 5 Médecins</title>
  <link rel="stylesheet" href="../css/styles.css">
  <style>
    .podium { display:flex; gap:20px; margin-bottom:30px; align-items:flex-end; }
    .podium-card { background:white; border-radius:10px; padding:20px;
                   box-shadow:0 2px 10px rgba(0,0,0,.1); text-align:center; flex:1; }
    .rang-1 { border-top:4px solid gold;   }
    .rang-2 { border-top:4px solid silver; }
    .rang-3 { border-top:4px solid #cd7f32; }
    .medaille { font-size:2em; }
  </style>
</head>
<body>
<div class="navbar">
  <span>🏥 MedRDV</span>
  <div>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">
  <h2 style="margin-bottom:24px">🏆 Top 5 — Médecins les plus consultés</h2>

  <% if (top5.isEmpty()) { %>
    <p>Aucune donnée disponible pour le moment.</p>
  <% } else { %>
  <table>
    <tr>
      <th>Rang</th>
      <th>Médecin</th>
      <th>Spécialité</th>
      <th>Lieu</th>
      <th>Tarif/h</th>
    </tr>
    <% String[] medailles = {"🥇","🥈","🥉","4️⃣","5️⃣"};
       for (int i = 0; i < top5.size(); i++) {
           Medecin m = top5.get(i); %>
    <tr <% if (i == 0) out.print("style='background:#fffbe6; font-weight:bold'"); %>>
      <td style="text-align:center; font-size:1.4em"><%= medailles[i] %></td>
      <td>Dr. <%= m.getNommed() %></td>
      <td><%= m.getSpecialite() %></td>
      <td><%= m.getLieu() %></td>
      <td><%= m.getTaux_horaire() %> Ar</td>
    </tr>
    <% } %>
  </table>
  <% } %>
</div>
</body>
</html>