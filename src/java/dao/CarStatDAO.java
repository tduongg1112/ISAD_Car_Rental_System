package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import model.CarStat;
import model.ContractDetail;

public class CarStatDAO extends DAO {

    public CarStatDAO() {
        super();
    }

    // Revenue
    public ArrayList<CarStat> getCarRevenue(Date startDate, Date endDate) {
        ArrayList<CarStat> list = new ArrayList<>();
        String sql = "SELECT c.id, c.carName, c.carType, c.modelYear, c.rentalPrice, "
                + "COALESCE(SUM( "
                + "    ct.contractValue / (SELECT COUNT(*) FROM tblContractDetail cd2 WHERE cd2.tblContractid = ct.id) "
                + "), 0) AS totalRevenue "
                + "FROM tblCar c "
                + "LEFT JOIN tblContractDetail cd ON cd.tblCarid = c.id "
                + "AND (cd.rentalStartDate <= ? AND cd.rentalEndDate >= ?) "
                + "LEFT JOIN tblContract ct ON ct.id = cd.tblContractid "
                + "GROUP BY c.id, c.carName, c.carType, c.modelYear, c.rentalPrice "
                + "ORDER BY totalRevenue DESC, c.id ASC";
                
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, endDate);
            ps.setDate(2, startDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CarStat item = new CarStat();
                item.setId(rs.getInt("id")); 
                item.setCarName(rs.getString("carName"));
                item.setCarType(rs.getString("carType"));
                item.setModelYear(rs.getString("modelYear"));
                item.setRentalPrice(rs.getFloat("rentalPrice"));
                item.setTotalRevenue(rs.getFloat("totalRevenue"));
                
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Contract
    public ArrayList<ContractDetail> getContractSummary(int carId, Date startDate, Date endDate) {
        ArrayList<ContractDetail> list = new ArrayList<>();
        String sql = "SELECT ct.id AS contractId, ct.contractValue, cd.rentalStartDate, cd.rentalEndDate "
                + "FROM tblContractDetail cd "
                + "JOIN tblContract ct ON ct.id = cd.tblContractid "
                + "WHERE cd.tblCarid = ? "
                + "AND cd.rentalStartDate <= ? AND cd.rentalEndDate >= ? "
                + "ORDER BY cd.rentalStartDate DESC";
                
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, carId);
            ps.setDate(2, endDate);
            ps.setDate(3, startDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractDetail summary = new ContractDetail();
                summary.setContractId(rs.getInt("contractId"));
                summary.setContractValue(rs.getFloat("contractValue"));
                summary.setRentalStartDate(rs.getDate("rentalStartDate"));
                summary.setRentalEndDate(rs.getDate("rentalEndDate"));
                list.add(summary);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}