package dao;

import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Car;


public class CarDAO extends DAO {
    public CarDAO(){
        super();
    }
    
//    public ArrayList<Car> getAllCars(){
//        ArrayList<Car> carList = new ArrayList<>();
//        String sql = "SELECT * FROM tblCar ORDER BY id";
//        
//        try {
//            PreparedStatement ps = con.prepareStatement(sql);
//            ResultSet rs = ps.executeQuery();
//            
//            while(rs.next()){
//                Car car = new Car();
//                car.setId(rs.getInt("id"));
//                car.setCarName(rs.getString("carName"));
//                car.setCarType(rs.getString("carType"));
//                car.setModelYear(rs.getString("modelYear"));
//                car.setLicensePlate(rs.getString("licensePlate"));
//                car.setRentalPrice(rs.getFloat("rentalPrice"));
//                car.setColor(rs.getString("color"));
//                car.setDescription(rs.getString("description"));
//                carList.add(car);
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return carList;
//    }
    
    public Car getCarById(int id){
        Car car = null;
        String sql = "SELECT * FROM tblCar WHERE id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()){
                car = new Car();
                car.setId(rs.getInt("id"));
                car.setCarName(rs.getString("carName"));
                car.setCarType(rs.getString("carType"));
                car.setModelYear(rs.getString("modelYear"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setRentalPrice(rs.getFloat("rentalPrice"));
                car.setColor(rs.getString("color"));
                car.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return car;
    }
    
    public ArrayList<Car> searchCarsByName(String keyword){
        ArrayList<Car> carList = new ArrayList<>();
        String sql = "SELECT * FROM tblCar WHERE LOWER(carName) LIKE LOWER(?) ORDER BY id";
        
        try{
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setCarName(rs.getString("carName"));
                car.setCarType(rs.getString("carType"));
                car.setModelYear(rs.getString("modelYear"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setRentalPrice(rs.getFloat("rentalPrice"));
                car.setColor(rs.getString("color"));
                car.setDescription(rs.getString("description"));
                carList.add(car);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return carList;
    }
    
    public boolean updateCar(Car car){
        String sql = "UPDATE tblCar SET carName = ?, carType = ?, modelYear = ?, licensePlate = ?, rentalPrice = ?, color = ?, description = ? "
                    + "WHERE id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, car.getCarName());
            ps.setString(2, car.getCarType());
            ps.setString(3, car.getModelYear());
            ps.setString(4, car.getLicensePlate());
            ps.setFloat(5, car.getRentalPrice());
            ps.setString(6, car.getColor());
            ps.setString(7, car.getDescription());
            ps.setInt(8, car.getId());
            
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if(e.getMessage().contains("unique constraint")) {
                System.out.println("Trùng biển số xe, vui lòng thử lại!");
            }
            return false;
        }
    }
}
