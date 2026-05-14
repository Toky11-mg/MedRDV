package mg.itu.model;

public class Medecin {
    private String idmed;
    private String nommed;
    private String specialite;
    private int    taux_horaire;
    private String lieu;
    private String email;
    private String password;

    public Medecin() {}

    public Medecin(String idmed, String nommed, String specialite,
                   int taux_horaire, String lieu, String email, String password) {
        this.idmed        = idmed;
        this.nommed       = nommed;
        this.specialite   = specialite;
        this.taux_horaire = taux_horaire;
        this.lieu         = lieu;
        this.email        = email;
        this.password     = password;
    }

    public String getIdmed()               { return idmed; }
    public void   setIdmed(String v)       { this.idmed = v; }
    public String getNommed()              { return nommed; }
    public void   setNommed(String v)      { this.nommed = v; }
    public String getSpecialite()          { return specialite; }
    public void   setSpecialite(String v)  { this.specialite = v; }
    public int    getTaux_horaire()        { return taux_horaire; }
    public void   setTaux_horaire(int v)   { this.taux_horaire = v; }
    public String getLieu()                { return lieu; }
    public void   setLieu(String v)        { this.lieu = v; }
    public String getEmail()               { return email; }
    public void   setEmail(String v)       { this.email = v; }
    public String getPassword()            { return password; }
    public void   setPassword(String v)    { this.password = v; }
}