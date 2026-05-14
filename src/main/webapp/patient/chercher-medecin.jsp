<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.*, mg.itu.dao.*, java.util.*" %>
<%
    if (session.getAttribute("patient") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    MedecinDAO medecinDAO = new MedecinDAO();
    String keyword    = request.getParameter("keyword");
    String specialite = request.getParameter("specialite");

    List<Medecin> medecins;
    if (keyword != null && !keyword.isEmpty()) {
        medecins = medecinDAO.searchByNom(keyword);
    } else if (specialite != null && !specialite.isEmpty()) {
        medecins = medecinDAO.findBySpecialite(specialite);
    } else {
        medecins = medecinDAO.findAll();
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chercher un médecin</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="navbar">
  <span>🏥 MedRDV</span>
  <div>
    <a href="dashboard.jsp">🏠 Accueil</a>
    <a href="logout.jsp">🚪 Déconnexion</a>
  </div>
</div>

<div class="container">
  <h2 style="margin-bottom:20px">🔍 Rechercher un médecin</h2>

  <!-- Formulaire de recherche -->
  <form method="get" style="display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap">
    <input type="text" name="keyword" placeholder="Nom du médecin..."
           value="<%= keyword != null ? keyword : "" %>"
           style="padding:10px; border:1px solid #ddd; border-radius:6px; flex:1">

    <select name="specialite" style="padding:10px; border:1px solid #ddd; border-radius:6px">
      <option value="">-- Toutes spécialités --</option>
      <option value="Cardiologie"   <%= "Cardiologie".equals(specialite)   ? "selected" : "" %>>Cardiologie</option>
      <option value="Pédiatrie"     <%= "Pédiatrie".equals(specialite)     ? "selected" : "" %>>Pédiatrie</option>
      <option value="Dermatologie"  <%= "Dermatologie".equals(specialite)  ? "selected" : "" %>>Dermatologie</option>
      <option value="Généraliste"   <%= "Généraliste".equals(specialite)   ? "selected" : "" %>>Généraliste</option>
      <option value="Gynécologie"   <%= "Gynécologie".equals(specialite)   ? "selected" : "" %>>Gynécologie</option>
    </select>

    <button type="submit" class="btn btn-patient" style="padding:10px 24px">Rechercher</button>
  </form>

  <!-- Résultats -->
  <% if (medecins.isEmpty()) { %>
    <p>Aucun médecin trouvé.</p>
  <% } else { %>
  <table>
    <tr>
      <th>Nom</th><th>Spécialité</th><th>Lieu</th><th>Tarif/h</th><th>Action</th>
    </tr>
    <% for (Medecin m : medecins) { %>
    <tr>
      <td>Dr. <%= m.getNommed() %></td>
      <td><%= m.getSpecialite() %></td>
      <td><%= m.getLieu() %></td>
      <td><%= m.getTaux_horaire() %> Ar</td>
      <td>
        <a href="prendre-rdv.jsp?idmed=<%= m.getIdmed() %>"
           class="btn btn-medecin"
           style="padding:8px 16px; font-size:0.9em">
          📅 Prendre RDV
        </a>
      </td>
    </tr>
    <% } %>
  </table>
  <% } %>
</div>
</body>
</html>