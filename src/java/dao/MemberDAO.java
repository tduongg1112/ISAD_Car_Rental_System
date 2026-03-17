package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Member;

public class MemberDAO extends DAO {

    public MemberDAO() {
        super(); 
    }

    public boolean checkLogin(Member member) {
        boolean result = false;
        String sql = "SELECT * FROM tblMember WHERE username = ? AND password = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, member.getUsername());
            ps.setString(2, member.getPassword());
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                member.setId(rs.getInt("id"));
                member.setFullName(rs.getString("fullName"));
                member.setEmail(rs.getString("email"));
                member.setPhoneNumber(rs.getString("phoneNumber"));
                member.setRole(rs.getString("role"));
              
                result = true; 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}