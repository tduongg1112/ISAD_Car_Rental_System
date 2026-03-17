package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import model.Car;
import model.Contract;
import model.ContractDetail;

public class ContractDAO extends DAO {

    public ContractDAO() {
        super();
    }

    public ArrayList<Car> searchAvailableCars(Date startDate, Date endDate) {
        ArrayList<Car> availableCars = new ArrayList<>();
        // Query to find cars that DO NOT have an overlapping contract in the given date range
        String sql = "SELECT * FROM tblCar "
                + "WHERE id NOT IN ("
                + "    SELECT tblCarid FROM tblContractDetail "
                + "    WHERE (rentalStartDate <= ? AND rentalEndDate >= ?) "
                + "       OR (rentalStartDate >= ? AND rentalStartDate <= ?) "
                + ") ORDER BY id";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, endDate);
            ps.setDate(2, startDate);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setCarName(rs.getString("carName"));
                car.setCarType(rs.getString("carType"));
                car.setModelYear(rs.getString("modelYear"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setRentalPrice(rs.getFloat("rentalPrice"));
                car.setColor(rs.getString("color"));
                car.setDescription(rs.getString("description"));
                availableCars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availableCars;
    }
    
    // Create new contract and contract detail
    public boolean createContract(Contract contract, ContractDetail detail) {
        boolean result = false;
        try {
            con.setAutoCommit(false);
            
            // 1. Insert Contract
            String sqlContract = "INSERT INTO tblContract(clientName, clientPhone, contractValue, depositAmount, status, tblMemberid) "
                               + "VALUES (?, ?, ?, ?, ?, ?)";
                               
            PreparedStatement psContract = con.prepareStatement(sqlContract, Statement.RETURN_GENERATED_KEYS);
            psContract.setString(1, contract.getClientName());
            psContract.setString(2, contract.getClientPhone());
            psContract.setFloat(3, contract.getContractValue());
            psContract.setFloat(4, contract.getDepositAmount());
            psContract.setString(5, contract.getStatus());
            psContract.setInt(6, contract.getMemberId());
            
            int affectedRows = psContract.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = psContract.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int contractId = generatedKeys.getInt(1);
                    contract.setId(contractId);
                    
                    // 2. Insert Contract Detail
                    String sqlDetail = "INSERT INTO tblContractDetail(tblContractid, tblCarid, rentalStartDate, rentalEndDate) "
                                     + "VALUES (?, ?, ?, ?)";
                    PreparedStatement psDetail = con.prepareStatement(sqlDetail);
                    psDetail.setInt(1, contractId);
                    psDetail.setInt(2, detail.getCarId());
                    psDetail.setDate(3, detail.getRentalStartDate());
                    psDetail.setDate(4, detail.getRentalEndDate());
                    
                    psDetail.executeUpdate();
                    
                    result = true;
                }
            }
            
            if (result) {
                con.commit();
            } else {
                con.rollback();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }
    
    // Update deposit amount
    public boolean updateDeposit(int contractId, float depositAmount) {
        String sql = "UPDATE tblContract SET depositAmount = ?, status = 'Deposited' WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setFloat(1, depositAmount);
            ps.setInt(2, contractId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Search contracts by keyword (client name or phone)
    public ArrayList<Contract> searchContracts(String keyword) {
        ArrayList<Contract> list = new ArrayList<>();
        String sql = "SELECT * FROM tblContract WHERE clientName ILIKE ? OR clientPhone ILIKE ? ORDER BY id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setCreatedDate(rs.getDate("createdDate"));
                c.setClientName(rs.getString("clientName"));
                c.setClientPhone(rs.getString("clientPhone"));
                c.setContractValue(rs.getFloat("contractValue"));
                c.setDepositAmount(rs.getFloat("depositAmount"));
                c.setStatus(rs.getString("status"));
                c.setMemberId(rs.getInt("tblMemberid"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get all contract details with car info mapped to those details
    public ArrayList<ContractDetail> getContractDetails(int contractId) {
        ArrayList<ContractDetail> list = new ArrayList<>();
        String sql = "SELECT cd.*, c.carName, c.licensePlate, c.rentalPrice "
                   + "FROM tblContractDetail cd "
                   + "JOIN tblCar c ON cd.tblCarid = c.id "
                   + "WHERE cd.tblContractid = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractDetail cd = new ContractDetail();
                cd.setId(rs.getInt("id"));
                cd.setContractId(rs.getInt("tblContractid"));
                cd.setCarId(rs.getInt("tblCarid"));
                cd.setRentalStartDate(rs.getDate("rentalStartDate"));
                cd.setRentalEndDate(rs.getDate("rentalEndDate"));
                
                // Set extra joined fields
                cd.setCarName(rs.getString("carName"));
                cd.setLicensePlate(rs.getString("licensePlate"));
                cd.setRentalPrice(rs.getFloat("rentalPrice"));
                list.add(cd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Contract getContractById(int id) {
        String sql = "SELECT * FROM tblContract WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setCreatedDate(rs.getDate("createdDate"));
                c.setClientName(rs.getString("clientName"));
                c.setClientPhone(rs.getString("clientPhone"));
                c.setContractValue(rs.getFloat("contractValue"));
                c.setDepositAmount(rs.getFloat("depositAmount"));
                c.setStatus(rs.getString("status"));
                c.setMemberId(rs.getInt("tblMemberid"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
