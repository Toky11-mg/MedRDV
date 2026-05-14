<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Medecin, mg.itu.dao.MedecinDAO" %>
<%
    if ("POST".equals(request.getMethod())) {
        Medecin m = new Medecin();
        m.setIdmed       ("MED" + System.currentTimeMillis());
        m.setNommed      (request.getParameter("nommed"));
        m.setSpecialite  (request.getParameter("specialite"));
        m.setTaux_horaire(Integer.parseInt(request.getParameter("taux_horaire")));
        m.setLieu        (request.getParameter("lieu"));
        m.setEmail       (request.getParameter("email"));
        m.setPassword    (request.getParameter("password"));
        try {
            new MedecinDAO().create(m);
            response.sendRedirect("login.jsp?inscrit=1");
            return;
        } catch (Exception e) {
            request.setAttribute("erreur", "Erreur : " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Inscription Médecin</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="form-box">
  <h2>📋 Créer un compte Médecin</h2>
  <% if (request.getAttribute("erreur") != null) { %>
    <p class="erreur"><%= request.getAttribute("erreur") %></p>
  <% } %>
  <form method="post">
    <label>Nom complet</label>
    <input type="text" name="nommed" required placeholder="Ex: Andry Rakoto">

    <label>Spécialité</label>
    <select name="specialite" required>
      <option value="">-- Choisir --</option>
      <option value="Cardiologie">Cardiologie</option>
      <option value="Pédiatrie">Pédiatrie</option>
      <option value="Dermatologie">Dermatologie</option>
      <option value="Généraliste">Généraliste</option>
      <option value="Gynécologie">Gynécologie</option>
      <option value="Neurologie">Neurologie</option>
      <option value="Ophtalmologie">Ophtalmologie</option>
      <option value="Orthopédie">Orthopédie</option>
    </select>

    <label>Tarif horaire (Ar)</label>
    <input type="number" name="taux_horaire" required placeholder="Ex: 50000" min="0">

    <label>Lieu / Cabinet</label>
    <input type="text" name="lieu" required placeholder="Ex: Antananarivo, Analakely">

    <label>Email</label>
    <input type="email" name="email" required placeholder="votre@email.com">

    <label>Mot de passe</label>
    <input type="password" name="password" required minlength="4">

    <button type="submit">S'inscrire</button>
  </form>
  <p>Déjà inscrit ? <a href="login.jsp">Se connecter</a></p>
</div>
</body>
</html>