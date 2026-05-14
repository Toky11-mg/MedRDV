package mg.itu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mg.itu.model.Patient;
import mg.itu.util.DBConnection;

public class PatientDAO {

    // ── CRÉER ──────────────────────────────────────────────
    public void create(Patient p) throws SQLException {
        String sql = "INSERT INTO patient(idpat,nom_pat,datenais,email,password) VALUES(?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getIdpat());
            ps.setString(2, p.getNom_pat());
            ps.setDate  (3, p.getDatenais());
            ps.setString(4, p.getEmail());
            ps.setString(5, p.getPassword());
            ps.executeUpdate();
        }
    }

    // ── LISTER TOUS ────────────────────────────────────────
    public List<Patient> findAll() throws SQLException {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT * FROM patient ORDER BY nom_pat";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ── TROUVER PAR ID ─────────────────────────────────────
    public Patient findById(String id) throws SQLException {
        String sql = "SELECT * FROM patient WHERE idpat = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    // ── LOGIN ──────────────────────────────────────────────
    public Patient login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM patient WHERE email=? AND password=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    // ── MODIFIER ───────────────────────────────────────────
    public void update(Patient p) throws SQLException {
        String sql = "UPDATE patient SET nom_pat=?,datenais=?,email=?,password=? WHERE idpat=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getNom_pat());
            ps.setDate  (2, p.getDatenais());
            ps.setString(3, p.getEmail());
            ps.setString(4, p.getPassword());
            ps.setString(5, p.getIdpat());
            ps.executeUpdate();
        }
    }

    // ── SUPPRIMER ──────────────────────────────────────────
    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM patient WHERE idpat=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.executeUpdate();
        }
    }

    // ── MAPPING ResultSet → Patient ────────────────────────
    private Patient map(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setIdpat   (rs.getString("idpat"));
        p.setNom_pat (rs.getString("nom_pat"));
        p.setDatenais(rs.getDate("datenais"));
        p.setEmail   (rs.getString("email"));
        p.setPassword(rs.getString("password"));
        return p;
    }
}