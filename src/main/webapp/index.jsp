<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MedRDV — Gestion de rendez-vous médicaux</title>
  <link rel="stylesheet" href="css/styles.css?v=2">
  <style>
    /* Particules flottantes */
    .particle {
      position: absolute;
      border-radius: 50%;
      background: rgba(233,69,96,.15);
      animation: float linear infinite;
    }
    @keyframes float {
      0%   { transform: translateY(100vh) scale(0); opacity: 0; }
      10%  { opacity: 1; }
      90%  { opacity: 1; }
      100% { transform: translateY(-100px) scale(1); opacity: 0; }
    }

    /* Ligne animée sous le titre */
    .hero-underline {
      width: 80px; height: 4px;
      background: linear-gradient(90deg, var(--accent), transparent);
      margin: 16px auto 32px;
      border-radius: 2px;
      animation: expandLine 1s ease .5s both;
    }
    @keyframes expandLine {
      from { width: 0; opacity: 0; }
      to   { width: 80px; opacity: 1; }
    }

    /* Cards de choix */
    .choice-card {
      background: rgba(255,255,255,.06);
      border: 1px solid rgba(255,255,255,.1);
      border-radius: var(--radius-lg);
      padding: 40px 36px;
      width: 240px;
      text-align: center;
      cursor: pointer;
      text-decoration: none;
      transition: all .3s;
      position: relative;
      overflow: hidden;
      animation: slideUp .5s ease both;
    }

    .choice-card:nth-child(2) { animation-delay: .15s; }

    .choice-card::before {
      content: '';
      position: absolute;
      bottom: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, var(--accent), transparent);
      transform: scaleX(0);
      transition: transform .3s;
    }

    .choice-card:hover {
      background: rgba(255,255,255,.10);
      border-color: rgba(233,69,96,.4);
      transform: translateY(-8px);
      box-shadow: 0 20px 40px rgba(0,0,0,.3);
    }

    .choice-card:hover::before { transform: scaleX(1); }

    .choice-card.medecin::before {
      background: linear-gradient(90deg, var(--success), transparent);
    }

    .choice-card .icon {
      width: 64px; height: 64px;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 20px;
      font-size: 1.8em;
    }

    .choice-card.patient .icon {
      background: rgba(233,69,96,.15);
      border: 2px solid rgba(233,69,96,.3);
    }

    .choice-card.medecin .icon {
      background: rgba(15,154,114,.15);
      border: 2px solid rgba(15,154,114,.3);
    }

    .choice-card h3 {
      color: var(--white);
      font-size: 1.1em;
      font-weight: 700;
      margin-bottom: 8px;
    }

    .choice-card p {
      color: rgba(255,255,255,.5);
      font-size: .82em;
      margin-bottom: 24px;
      line-height: 1.5;
    }

    .choice-card .btn-card {
      display: inline-block;
      padding: 10px 24px;
      border-radius: var(--radius-full);
      font-size: .85em;
      font-weight: 700;
      text-decoration: none;
      transition: all .2s;
      font-family: inherit;
    }

    .choice-card.patient .btn-card {
      background: var(--accent);
      color: white;
      box-shadow: 0 4px 15px rgba(233,69,96,.35);
    }

    .choice-card.medecin .btn-card {
      background: var(--success);
      color: white;
      box-shadow: 0 4px 15px rgba(15,154,114,.35);
    }

    /* Stats en bas */
    .hero-stats {
      display: flex;
      gap: 48px;
      margin-top: 64px;
      position: relative;
      z-index: 1;
      animation: fadeIn 1s ease 1s both;
    }

    .hero-stat { text-align: center; }
    .hero-stat .nb {
      font-size: 2em;
      font-weight: 800;
      color: var(--white);
      display: block;
    }
    .hero-stat .lbl {
      font-size: .78em;
      color: rgba(255,255,255,.45);
      text-transform: uppercase;
      letter-spacing: .8px;
      font-weight: 500;
    }

    .hero-divider {
      width: 1px;
      background: rgba(255,255,255,.1);
      align-self: stretch;
    }

    /* Badge nouveau */
    .badge-new {
      display: inline-block;
      background: rgba(233,69,96,.2);
      color: var(--accent);
      border: 1px solid rgba(233,69,96,.3);
      padding: 4px 14px;
      border-radius: var(--radius-full);
      font-size: .75em;
      font-weight: 700;
      letter-spacing: 1px;
      text-transform: uppercase;
      margin-bottom: 20px;
      animation: fadeIn .5s ease both;
    }

    /* Scroll indicator */
    .scroll-hint {
      position: absolute;
      bottom: 32px;
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      color: rgba(255,255,255,.3);
      font-size: .75em;
      letter-spacing: .5px;
      animation: bounce 2s ease infinite;
    }

    @keyframes bounce {
      0%, 100% { transform: translateX(-50%) translateY(0); }
      50%       { transform: translateX(-50%) translateY(6px); }
    }
  </style>
</head>
<body>

<!-- Particules -->
<div class="hero" id="hero">

  <!-- Particules générées par JS -->
  <div id="particles"></div>

  <!-- Badge -->
  <div class="badge-new">✦ Plateforme Médicale Numérique</div>

  <!-- Titre principal -->
  <h1 style="position:relative; z-index:1">
    Med<span style="color:var(--accent)">RDV</span>
  </h1>
  <div class="hero-underline"></div>

  <!-- Sous-titre -->
  <p style="position:relative; z-index:1; animation: fadeIn .5s ease .3s both; opacity:0">
    Prenez rendez-vous avec les meilleurs médecins<br>
    en quelques secondes, en ligne, 24h/24.
  </p>

  <!-- Cards de choix -->
  <div class="choix" style="gap:24px; position:relative; z-index:1">

    <a href="patient/login.jsp" class="choice-card patient">
      <div class="icon">👤</div>
      <h3>Espace Patient</h3>
      <p>Prenez rendez-vous avec un médecin, gérez vos consultations.</p>
      <span class="btn-card">Connexion →</span>
    </a>

    <a href="medecin/login.jsp" class="choice-card medecin">
      <div class="icon">🩺</div>
      <h3>Espace Médecin</h3>
      <p>Gérez votre agenda, vos patients et vos disponibilités.</p>
      <span class="btn-card">Connexion →</span>
    </a>

  </div>

  <!-- Stats -->
  <div class="hero-stats">
    <div class="hero-stat">
      <span class="nb" id="statMed">0</span>
      <span class="lbl">Médecins</span>
    </div>
    <div class="hero-divider"></div>
    <div class="hero-stat">
      <span class="nb" id="statPat">0</span>
      <span class="lbl">Patients</span>
    </div>
    <div class="hero-divider"></div>
    <div class="hero-stat">
      <span class="nb" id="statRdv">0</span>
      <span class="lbl">RDV pris</span>
    </div>
    <div class="hero-divider"></div>
    <div class="hero-stat">
      <span class="nb">24/7</span>
      <span class="lbl">Disponible</span>
    </div>
  </div>

  <!-- Scroll hint -->
  <div class="scroll-hint">
    ▼ Défiler
  </div>

</div>

<!-- Section fonctionnalités -->
<div style="background: var(--white); padding: 80px 24px;">
  <div style="max-width: 900px; margin: 0 auto; text-align: center;">

    <h2 style="font-size: 2em; font-weight: 800; color: var(--dark); margin-bottom: 12px;">
      Pourquoi choisir <span style="color: var(--accent)">MedRDV</span> ?
    </h2>
    <p style="color: var(--gray-600); margin-bottom: 48px; font-size: 1.05em;">
      Une plateforme simple, rapide et sécurisée.
    </p>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px;">

      <div style="background: var(--gray-50); border-radius: var(--radius-md);
                  padding: 32px 24px; border-top: 3px solid var(--accent);
                  transition: all .25s; cursor: default;"
           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.1)'"
           onmouseout="this.style.transform=''; this.style.boxShadow=''">
        <div style="font-size: 2em; margin-bottom: 16px;">📅</div>
        <h3 style="font-size: 1em; font-weight: 700; color: var(--dark); margin-bottom: 8px;">
          Réservation en ligne
        </h3>
        <p style="font-size: .88em; color: var(--gray-600); line-height: 1.6;">
          Prenez rendez-vous à toute heure sans attente ni appel téléphonique.
        </p>
      </div>

      <div style="background: var(--gray-50); border-radius: var(--radius-md);
                  padding: 32px 24px; border-top: 3px solid var(--success);
                  transition: all .25s; cursor: default;"
           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.1)'"
           onmouseout="this.style.transform=''; this.style.boxShadow=''">
        <div style="font-size: 2em; margin-bottom: 16px;">📧</div>
        <h3 style="font-size: 1em; font-weight: 700; color: var(--dark); margin-bottom: 8px;">
          Confirmation par mail
        </h3>
        <p style="font-size: .88em; color: var(--gray-600); line-height: 1.6;">
          Recevez automatiquement un email de confirmation ou d'annulation.
        </p>
      </div>

      <div style="background: var(--gray-50); border-radius: var(--radius-md);
                  padding: 32px 24px; border-top: 3px solid #4361ee;
                  transition: all .25s; cursor: default;"
           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.1)'"
           onmouseout="this.style.transform=''; this.style.boxShadow=''">
        <div style="font-size: 2em; margin-bottom: 16px;">🔒</div>
        <h3 style="font-size: 1em; font-weight: 700; color: var(--dark); margin-bottom: 8px;">
          Aucune double réservation
        </h3>
        <p style="font-size: .88em; color: var(--gray-600); line-height: 1.6;">
          Les créneaux réservés sont bloqués en temps réel pour tous les patients.
        </p>
      </div>

      <div style="background: var(--gray-50); border-radius: var(--radius-md);
                  padding: 32px 24px; border-top: 3px solid #f4a261;
                  transition: all .25s; cursor: default;"
           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.1)'"
           onmouseout="this.style.transform=''; this.style.boxShadow=''">
        <div style="font-size: 2em; margin-bottom: 16px;">🔍</div>
        <h3 style="font-size: 1em; font-weight: 700; color: var(--dark); margin-bottom: 8px;">
          Recherche avancée
        </h3>
        <p style="font-size: .88em; color: var(--gray-600); line-height: 1.6;">
          Trouvez le bon médecin par nom ou spécialité en quelques secondes.
        </p>
      </div>

    </div>
  </div>
</div>

<!-- Footer -->
<footer style="background: var(--dark); padding: 32px 24px; text-align: center;">
  <p style="color: rgba(255,255,255,.35); font-size: .82em;">
    © 2026 MedRDV — Gestion de rendez-vous médicaux en ligne
    <span style="margin: 0 12px; color: rgba(255,255,255,.15)">|</span>
    Développé avec ❤️ en Java JSP / PostgreSQL
  </p>
</footer>

<script>
  // Particules flottantes
  const hero = document.getElementById('particles');
  for (let i = 0; i < 12; i++) {
    const p = document.createElement('div');
    p.className = 'particle';
    const size = Math.random() * 60 + 20;
    p.style.cssText = `
      width: ${size}px; height: ${size}px;
      left: ${Math.random() * 100}%;
      animation-duration: ${Math.random() * 10 + 8}s;
      animation-delay: ${Math.random() * 8}s;
    `;
    hero.appendChild(p);
  }

  // Compteurs animés
  function animateCount(el, target, suffix) {
    let current = 0;
    const step = Math.ceil(target / 40);
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current + (suffix || '');
      if (current >= target) clearInterval(timer);
    }, 40);
  }

  setTimeout(() => {
    animateCount(document.getElementById('statMed'), 24, '+');
    animateCount(document.getElementById('statPat'), 150, '+');
    animateCount(document.getElementById('statRdv'), 320, '+');
  }, 800);
</script>

</body>
</html>