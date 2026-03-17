package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    public static Connection con; 

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:postgresql://localhost:5433/car_rental_system";
            String dbClass = "org.postgresql.Driver";
            String username = "postgres"; 
            String password = "1112"; 

            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, username, password);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void main(String[] args) {
        DAO dao = new DAO(); 
        if (dao.con != null) {
            System.out.println("Connection successful!"); 
        } else {
            System.out.println("Connection failed!");
        }
    }
}