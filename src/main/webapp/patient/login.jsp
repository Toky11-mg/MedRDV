<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.itu.model.Patient, mg.itu.dao.PatientDAO" %>
<%
    if ("POST".equals(request.getMethod())) {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        Patient p       = new PatientDAO().login(email, password);
        if (p != null) {
            session.setAttribute("patient", p);
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            request.setAttribute("erreur", "Email ou mot de passe incorrect.");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Connexion Patient — MedRDV</title>
  <link rel="stylesheet" href="../css/styles.css?v=2">
  <style>
    body {
      background: linear-gradient(160deg, var(--dark) 0%, var(--dark-blue) 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .login-wrapper {
      width: 100%;
      max-width: 440px;
      padding: 20px;
    }

    /* Logo en haut */
    .login-logo {
      text-align: center;
      margin-bottom: 32px;
      animation: fadeIn .4s ease;
    }

    .login-logo h1 {
      font-size: 2.2em;
      font-weight: 800;
      color: var(--white);
      letter-spacing: 1px;
    }

    .login-logo h1 span { color: var(--accent); }

    .login-logo p {
      color: rgba(255,255,255,.45);
      font-size: .88em;
      margin-top: 6px;
    }

    /* Box login */
    .login-box {
      background: var(--white);
      padding: 40px 36px;
      border-radius: var(--radius-lg);
      box-shadow: 0 20px 60px rgba(0,0,0,.3);
      border-top: 4px solid var(--accent);
      animation: slideUp .4s ease;
    }

    .login-box h2 {
      font-size: 1.3em;
      font-weight: 800;
      color: var(--dark);
      margin-bottom: 6px;
    }

    .login-box .subtitle {
      font-size: .85em;
      color: var(--gray-600);
      margin-bottom: 28px;
    }

    .input-group {
      margin-bottom: 18px;
    }

    .input-group label {
      display: block;
      font-size: .78em;
      font-weight: 700;
      color: var(--gray-600);
      text-transform: uppercase;
      letter-spacing: .6px;
      margin-bottom: 6px;
    }

    .input-group input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid var(--gray-200);
      border-radius: var(--radius-md);
      font-size: .95em;
      font-family: inherit;
      color: var(--dark);
      background: var(--gray-50);
      transition: all .2s;
    }

    .input-group input:focus {
      outline: none;
      border-color: var(--accent);
      box-shadow: 0 0 0 4px rgba(233,69,96,.1);
      background: var(--white);
    }

    .btn-login {
      width: 100%;
      padding: 14px;
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
      margin-top: 8px;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(233,69,96,.4);
    }

    .login-footer {
      text-align: center;
      margin-top: 20px;
      font-size: .88em;
      color: var(--gray-600);
    }

    .login-footer a {
      color: var(--accent);
      font-weight: 700;
      text-decoration: none;
    }

    .login-footer a:hover { text-decoration: underline; }

    .back-link {
      text-align: center;
      margin-top: 24px;
      animation: fadeIn .5s ease .3s both;
      opacity: 0;
    }

    .back-link a {
      color: rgba(255,255,255,.45);
      font-size: .85em;
      text-decoration: none;
      transition: color .2s;
    }

    .back-link a:hover { color: rgba(255,255,255,.8); }

    /* Badge type compte */
    .account-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(233,69,96,.08);
      border: 1px solid rgba(233,69,96,.2);
      color: var(--accent);
      padding: 6px 14px;
      border-radius: var(--radius-full);
      font-size: .8em;
      font-weight: 700;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>

<div class="login-wrapper">

  <!-- Logo -->
  <div class="login-logo">
    <h1>Med<span>RDV</span></h1>
    <p>Plateforme de gestion de rendez-vous médicaux</p>
  </div>

  <!-- Box -->
  <div class="login-box">

    <div class="account-badge">👤 Espace Patient</div>

    <h2>Bon retour !</h2>
    <p class="subtitle">Connectez-vous pour gérer vos rendez-vous.</p>

    <% if (request.getAttribute("erreur") != null) { %>
      <p class="erreur">❌ <%= request.getAttribute("erreur") %></p>
    <% } %>
    <% if ("1".equals(request.getParameter("inscrit"))) { %>
      <p class="succes">✅ Compte créé ! Connectez-vous.</p>
    <% } %>

    <form method="post">
      <div class="input-group">
        <label>Adresse email</label>
        <input type="email" name="email" required
               placeholder="votre@email.com" autofocus>
      </div>
      <div class="input-group">
        <label>Mot de passe</label>
        <input type="password" name="password" required
               placeholder="••••••••">
      </div>
      <button type="submit" class="btn-login">Se connecter →</button>
    </form>

    <div class="login-footer">
      Pas encore inscrit ?
      <a href="register.jsp">Créer un compte</a>
    </div>

  </div>

  <div class="back-link">
    <a href="../index.jsp">← Retour à l'accueil</a>
  </div>

</div>

</body>
</html>