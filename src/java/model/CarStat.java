package model;

public class CarStat extends Car {
    
    private float totalRevenue; 

    public CarStat() {
        super();
    }

    public float getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(float totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}