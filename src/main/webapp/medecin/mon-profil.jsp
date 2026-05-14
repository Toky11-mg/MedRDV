<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Medecin, mg.itu.dao.MedecinDAO" %>
<%
    Medecin medecin = (Medecin) session.getAttribute("medecin");
    if (medecin == null) { response.sendRedirect("login.jsp"); return; }

    String message = null;
    if ("POST".equals(request.getMethod())) {
        medecin.setNommed      (request.getParameter("nommed"));
        medecin.setSpecialite  (request.getParameter("specialite"));
        medecin.setTaux_horaire(Integer.parseInt(request.getParameter("taux_horaire")));
        medecin.setLieu        (request.getParameter("lieu"));
        medecin.setEmail       (request.getParameter("email"));
        String newPwd = request.getParameter("password");
        if (newPwd != null && !newPwd.isEmpty()) medecin.setPassword(newPwd);

        new MedecinDAO().update(medecin);
        session.setAttribute("medecin", medecin); // mettre à jour la session
        message = "✅ Profil mis à jour avec succès !";
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mon Profil</title>
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

<div class="form-box" style="max-width:520px; margin-top:40px">
  <h2>👤 Mon Profil</h2>
  <% if (message != null) { %>
    <p class="succes"><%= message %></p>
  <% } %>
  <form method="post">
    <label>Nom complet</label>
    <input type="text" name="nommed" required value="<%= medecin.getNommed() %>">

    <label>Spécialité</label>
    <select name="specialite" required>
      <% String[] specs = {"Cardiologie","Pédiatrie","Dermatologie",
                           "Généraliste","Gynécologie","Neurologie",
                           "Ophtalmologie","Orthopédie"}; %>
      <% for (String s : specs) { %>
        <option value="<%= s %>" <%= s.equals(medecin.getSpecialite()) ? "selected" : "" %>>
          <%= s %>
        </option>
      <% } %>
    </select>

    <label>Tarif horaire (Ar)</label>
    <input type="number" name="taux_horaire" required value="<%= medecin.getTaux_horaire() %>">

    <label>Lieu / Cabinet</label>
    <input type="text" name="lieu" required value="<%= medecin.getLieu() %>">

    <label>Email</label>
    <input type="email" name="email" required value="<%= medecin.getEmail() %>">

    <label>Nouveau mot de passe <small>(laisser vide pour ne pas changer)</small></label>
    <input type="password" name="password" placeholder="Nouveau mot de passe...">

    <button type="submit">💾 Enregistrer</button>
  </form>
</div>
</body>
</html>