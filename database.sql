-- ═══════════════════════════════════════════
-- MedRDV — Script base de données PostgreSQL
-- ═══════════════════════════════════════════

-- Créer l'utilisateur et la base
CREATE USER medr_user WITH PASSWORD 'admin123';
CREATE DATABASE medrdv OWNER medr_user;

-- Se connecter à la base
\c medrdv

-- Accorder les privilèges
GRANT ALL PRIVILEGES ON DATABASE medrdv TO medr_user;

-- ── TABLES ──────────────────────────────────

CREATE TABLE patient (
    idpat    VARCHAR(20)  PRIMARY KEY,
    nom_pat  VARCHAR(100) NOT NULL,
    datenais DATE         NOT NULL,
    email    VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);

CREATE TABLE medecin (
    idmed        VARCHAR(20)  PRIMARY KEY,
    nommed       VARCHAR(100) NOT NULL,
    specialite   VARCHAR(100) NOT NULL,
    taux_horaire INT          NOT NULL,
    lieu         VARCHAR(150),
    email        VARCHAR(100) UNIQUE,
    password     VARCHAR(255)
);

CREATE TABLE rdv (
    idrdv    VARCHAR(20) PRIMARY KEY,
    idmed    VARCHAR(20) NOT NULL REFERENCES medecin(idmed),
    idpat    VARCHAR(20) NOT NULL REFERENCES patient(idpat),
    date_rdv TIMESTAMP   NOT NULL,
    statut   VARCHAR(20) DEFAULT 'CONFIRME',
    UNIQUE (idmed, date_rdv)
);

-- ── DONNÉES DE TEST ─────────────────────────

INSERT INTO patient VALUES
('PAT001', 'Rakoto Jean',  '1990-05-15', 'rakoto@gmail.com', '1234'),
('PAT002', 'Rabe Marie',   '1985-03-20', 'rabe@gmail.com',   '1234'),
('PAT003', 'Valisoa Hery', '1995-08-10', 'valisoa@gmail.com','1234');

INSERT INTO medecin VALUES
('MED001', 'Dr. Andry', 'Cardiologie',   50000, 'Antananarivo', 'andry@gmail.com', '1234'),
('MED002', 'Dr. Soa',   'Pédiatrie',     40000, 'Antananarivo', 'soa@gmail.com',   '1234'),
('MED003', 'Dr. Hery',  'Dermatologie',  45000, 'Fianarantsoa', 'hery@gmail.com',  '1234'),
('MED004', 'Dr. Lanto', 'Généraliste',   35000, 'Antananarivo', 'lanto@gmail.com', '1234'),
('MED005', 'Dr. Vao',   'Gynécologie',   48000, 'Toamasina',    'vao@gmail.com',   '1234');

-- Permissions sur les tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO medr_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO medr_user;

