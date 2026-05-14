package mg.itu.model;

import java.sql.Date;

public class Patient {
    private String idpat;
    private String nom_pat;
    private Date   datenais;
    private String email;
    private String password;

    public Patient() {}

    public Patient(String idpat, String nom_pat, Date datenais, String email, String password) {
        this.idpat    = idpat;
        this.nom_pat  = nom_pat;
        this.datenais = datenais;
        this.email    = email;
        this.password = password;
    }

    // Getters & Setters
    public String getIdpat()            { return idpat; }
    public void   setIdpat(String v)    { this.idpat = v; }
    public String getNom_pat()          { return nom_pat; }
    public void   setNom_pat(String v)  { this.nom_pat = v; }
    public Date   getDatenais()         { return datenais; }
    public void   setDatenais(Date v)   { this.datenais = v; }
    public String getEmail()            { return email; }
    public void   setEmail(String v)    { this.email = v; }
    public String getPassword()         { return password; }
    public void   setPassword(String v) { this.password = v; }
}