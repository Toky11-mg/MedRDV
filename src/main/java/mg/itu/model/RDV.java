package mg.itu.model;

import java.sql.Timestamp;

public class RDV {
    private String    idrdv;
    private String    idmed;
    private String    idpat;
    private Timestamp date_rdv;
    private String    statut;

    // Champs joints (pour affichage)
    private String nommed;
    private String nom_pat;
    private String specialite;

    public RDV() {}

    public String    getIdrdv()              { return idrdv; }
    public void      setIdrdv(String v)      { this.idrdv = v; }
    public String    getIdmed()              { return idmed; }
    public void      setIdmed(String v)      { this.idmed = v; }
    public String    getIdpat()              { return idpat; }
    public void      setIdpat(String v)      { this.idpat = v; }
    public Timestamp getDate_rdv()           { return date_rdv; }
    public void      setDate_rdv(Timestamp v){ this.date_rdv = v; }
    public String    getStatut()             { return statut; }
    public void      setStatut(String v)     { this.statut = v; }
    public String    getNommed()             { return nommed; }
    public void      setNommed(String v)     { this.nommed = v; }
    public String    getNom_pat()            { return nom_pat; }
    public void      setNom_pat(String v)    { this.nom_pat = v; }
    public String    getSpecialite()         { return specialite; }
    public void      setSpecialite(String v) { this.specialite = v; }
}