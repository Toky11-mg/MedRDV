package mg.itu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mg.itu.model.Medecin;
import mg.itu.util.DBConnection;

public class MedecinDAO {

    public void create(Medecin m) throws SQLException {
        String sql = "INSERT INTO medecin(idmed,nommed,specialite,taux_horaire,lieu,email,password) VALUES(?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, m.getIdmed());
            ps.setString(2, m.getNommed());
            ps.setString(3, m.getSpecialite());
            ps.setInt   (4, m.getTaux_horaire());
            ps.setString(5, m.getLieu());
            ps.setString(6, m.getEmail());
            ps.setString(7, m.getPassword());
            ps.executeUpdate();
        }
    }

    public List<Medecin> findAll() throws SQLException {
        List<Medecin> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM medecin ORDER BY nommed")) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Medecin findById(String id) throws SQLException {
        String sql = "SELECT * FROM medecin WHERE idmed=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public Medecin login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM medecin WHERE email=? AND password=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    // ── Recherche par nom (LIKE) ───────────────────────────
    public List<Medecin> searchByNom(String keyword) throws SQLException {
        List<Medecin> list = new ArrayList<>();
        String sql = "SELECT * FROM medecin WHERE nommed ILIKE ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ── Par spécialité ────────────────────────────────────
    public List<Medecin> findBySpecialite(String spec) throws SQLException {
        List<Medecin> list = new ArrayList<>();
        String sql = "SELECT * FROM medecin WHERE specialite=? ORDER BY nommed";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, spec);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ── Top 5 médecins les plus consultés ─────────────────
    public List<Medecin> top5Consultes() throws SQLException {
        List<Medecin> list = new ArrayList<>();
        String sql = """
            SELECT m.*, COUNT(r.idrdv) AS nb
            FROM medecin m
            JOIN rdv r ON r.idmed = m.idmed
            WHERE r.statut = 'CONFIRME'
            GROUP BY m.idmed
            ORDER BY nb DESC
            LIMIT 5
            """;
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public void update(Medecin m) throws SQLException {
        String sql = "UPDATE medecin SET nommed=?,specialite=?,taux_horaire=?,lieu=?,email=?,password=? WHERE idmed=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, m.getNommed());
            ps.setString(2, m.getSpecialite());
            ps.setInt   (3, m.getTaux_horaire());
            ps.setString(4, m.getLieu());
            ps.setString(5, m.getEmail());
            ps.setString(6, m.getPassword());
            ps.setString(7, m.getIdmed());
            ps.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM medecin WHERE idmed=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.executeUpdate();
        }
    }

    private Medecin map(ResultSet rs) throws SQLException {
        Medecin m = new Medecin();
        m.setIdmed       (rs.getString("idmed"));
        m.setNommed      (rs.getString("nommed"));
        m.setSpecialite  (rs.getString("specialite"));
        m.setTaux_horaire(rs.getInt("taux_horaire"));
        m.setLieu        (rs.getString("lieu"));
        m.setEmail       (rs.getString("email"));
        m.setPassword    (rs.getString("password"));
        return m;
    }
}