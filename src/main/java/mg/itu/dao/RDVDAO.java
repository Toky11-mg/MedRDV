package mg.itu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import mg.itu.model.RDV;
import mg.itu.util.DBConnection;

public class RDVDAO {

    // ── CRÉER un RDV ──────────────────────────────────────
    public boolean create(RDV r) throws SQLException {
        // Vérifier d'abord si le créneau est libre
        if (!isCreneauLibre(r.getIdmed(), r.getDate_rdv())) {
            return false; // créneau déjà pris
        }
        String sql = "INSERT INTO rdv(idrdv,idmed,idpat,date_rdv,statut) VALUES(?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString   (1, r.getIdrdv());
            ps.setString   (2, r.getIdmed());
            ps.setString   (3, r.getIdpat());
            ps.setTimestamp(4, r.getDate_rdv());
            ps.setString   (5, "CONFIRME");
            ps.executeUpdate();
            return true;
        }
    }

    // ── Vérifier si créneau libre ─────────────────────────
    public boolean isCreneauLibre(String idmed, Timestamp dateRdv) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rdv WHERE idmed=? AND date_rdv=? AND statut='CONFIRME'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString   (1, idmed);
            ps.setTimestamp(2, dateRdv);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;
        }
        return false;
    }

    // ── Horaires disponibles d'un médecin ─────────────────
    // Génère les créneaux de 8h à 17h par heure pour une date donnée
    // et retire ceux déjà réservés
    public List<String> getCreneauxDisponibles(String idmed, String date) throws SQLException {
    // Créneaux possibles dans la journée
    List<String> tous = new ArrayList<>();
    String[] heures = {"08:00","09:00","10:00","11:00","12:00",
                       "13:00","14:00","15:00","16:00","17:00"};
    for (String h : heures) {
        tous.add(date + " " + h);
    }

    // ✅ CAST(? AS date) à la place de ?::date
    String sql = "SELECT TO_CHAR(date_rdv, 'YYYY-MM-DD HH24:MI') AS creneau "
               + "FROM rdv "
               + "WHERE idmed = ? "
               + "AND DATE(date_rdv) = CAST(? AS date) "
               + "AND statut = 'CONFIRME'";

    List<String> pris = new ArrayList<>();
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, idmed);
        ps.setString(2, date);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            pris.add(rs.getString("creneau"));
        }
    }

    tous.removeAll(pris);
    return tous;
}

    // ── RDV d'un patient ──────────────────────────────────
    public List<RDV> findByPatient(String idpat) throws SQLException {
        List<RDV> list = new ArrayList<>();
        String sql = """
            SELECT r.*, m.nommed, m.specialite
            FROM rdv r
            JOIN medecin m ON m.idmed = r.idmed
            WHERE r.idpat=?
            ORDER BY r.date_rdv DESC
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, idpat);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RDV rdv = map(rs);
                rdv.setNommed   (rs.getString("nommed"));
                rdv.setSpecialite(rs.getString("specialite"));
                list.add(rdv);
            }
        }
        return list;
    }

    // ── RDV d'un médecin ──────────────────────────────────
    public List<RDV> findByMedecin(String idmed) throws SQLException {
        List<RDV> list = new ArrayList<>();
        String sql = """
            SELECT r.*, p.nom_pat
            FROM rdv r
            JOIN patient p ON p.idpat = r.idpat
            WHERE r.idmed=?
            ORDER BY r.date_rdv DESC
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, idmed);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RDV rdv = map(rs);
                rdv.setNom_pat(rs.getString("nom_pat"));
                list.add(rdv);
            }
        }
        return list;
    }

    // ── Tous les RDV (admin) ───────────────────────────────
    public List<RDV> findAll() throws SQLException {
        List<RDV> list = new ArrayList<>();
        String sql = """
            SELECT r.*, m.nommed, p.nom_pat
            FROM rdv r
            JOIN medecin m ON m.idmed = r.idmed
            JOIN patient p ON p.idpat = r.idpat
            ORDER BY r.date_rdv DESC
            """;
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                RDV rdv = map(rs);
                rdv.setNommed (rs.getString("nommed"));
                rdv.setNom_pat(rs.getString("nom_pat"));
                list.add(rdv);
            }
        }
        return list;
    }

    // ── ANNULER un RDV ────────────────────────────────────
    public RDV annuler(String idrdv) throws SQLException {
        // D'abord récupérer le RDV pour envoyer le mail ensuite
        RDV rdv = findById(idrdv);
        String sql = "UPDATE rdv SET statut='ANNULE' WHERE idrdv=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, idrdv);
            ps.executeUpdate();
        }
        return rdv;
    }

    // ── TROUVER par ID ────────────────────────────────────
    public RDV findById(String idrdv) throws SQLException {
        String sql = """
            SELECT r.*, m.nommed, m.email AS email_med,
                   p.nom_pat, p.email AS email_pat
            FROM rdv r
            JOIN medecin m ON m.idmed = r.idmed
            JOIN patient p ON p.idpat = r.idpat
            WHERE r.idrdv=?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, idrdv);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RDV rdv = map(rs);
                rdv.setNommed (rs.getString("nommed"));
                rdv.setNom_pat(rs.getString("nom_pat"));
                return rdv;
            }
        }
        return null;
    }

    // ── SUPPRIMER un RDV ──────────────────────────────────
    public void delete(String idrdv) throws SQLException {
        String sql = "DELETE FROM rdv WHERE idrdv=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, idrdv);
            ps.executeUpdate();
        }
    }

    private RDV map(ResultSet rs) throws SQLException {
        RDV r = new RDV();
        r.setIdrdv   (rs.getString("idrdv"));
        r.setIdmed   (rs.getString("idmed"));
        r.setIdpat   (rs.getString("idpat"));
        r.setDate_rdv(rs.getTimestamp("date_rdv"));
        r.setStatut  (rs.getString("statut"));
        return r;
    }
}