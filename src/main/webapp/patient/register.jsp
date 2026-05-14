<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Patient, mg.itu.dao.PatientDAO, java.sql.Date" %>
<%
    if ("POST".equals(request.getMethod())) {
        Patient p = new Patient();
        p.setIdpat   ("PAT" + System.currentTimeMillis());
        p.setNom_pat (request.getParameter("nom_pat"));
        p.setDatenais(Date.valueOf(request.getParameter("datenais")));
        p.setEmail   (request.getParameter("email"));
        p.setPassword(request.getParameter("password"));
        try {
            new PatientDAO().create(p);
            response.sendRedirect("login.jsp?inscrit=1");
            return;
        } catch (Exception e) {
            request.setAttribute("erreur", "Email déjà utilisé ou erreur : " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Inscription Patient</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="form-box">
  <h2>📋 Créer un compte Patient</h2>
  <% if (request.getAttribute("erreur") != null) { %>
    <p class="erreur"><%= request.getAttribute("erreur") %></p>
  <% } %>
  <form method="post">
    <label>Nom complet</label>
    <input type="text" name="nom_pat" required placeholder="Ex: Rakoto Jean">

    <label>Date de naissance</label>
    <input type="date" name="datenais" required>

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