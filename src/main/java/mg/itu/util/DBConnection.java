package mg.itu.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL      = "jdbc:postgresql://localhost:5432/medrdv";
    private static final String USER     = "medr_user";
    private static final String PASSWORD = "admin123"; // 

    private static Connection connection = null;

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            } catch (ClassNotFoundException e) {
                throw new SQLException("Driver PostgreSQL introuvable", e);
            }
        }
        return connection;
    }
}