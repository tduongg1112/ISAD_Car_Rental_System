# Car Rental System - Phân tích thiết kế Hệ thống thông tin

Một hệ thống quản lý cho thuê xe ô tô được xây dựng và phát triển trên nền tảng Java Web (Học phần Information System Analysis and Design). Dự án hỗ trợ quản lý thông tin xe, lịch đặt xe, hợp đồng thuê xe, hoá đơn đặt cọc và báo cáo doanh thu chi tiết dành cho Quản lý (Manager) và Nhân viên Kinh doanh (Sales Staff).

## 🚀 Tính Năng Chính
- **Đăng nhập Hệ thống:** Phân quyền theo Role riêng biệt (`manager`, `salestaff`).
- **Quản lý Xe (Manager):** Bảng điều khiển xem danh sách, tìm kiếm và chỉnh sửa thông tin xe ô tô.
- **Tìm Xe Trống (Sale & Manager):** Tìm kiếm các xe khả dụng không bị trùng lịch theo khoảng thời gian đặt trước (`Start Date` - `End Date`).
- **Đặt Xe & Cọc Tiền (Sale & Manager):** Khai báo thông tin khách hàng, tự động lấy ID nhân viên Sales tạo hợp đồng, tính tổng chi phí và thanh toán tiền cọc giúp chuyển trạng thái đơn (Booked & Deposited).
- **Quản Lý Đơn Hàng:** Tìm kiếm khách hàng theo Tên/SĐT, liệt kê các hoá đơn giao dịch, xem chi tiết hợp đồng gồm loại xe đã thuê, tiền cọc và công nợ.
- **Thống Kê Doanh Thu:** Xuất báo cáo doanh thu các xe theo dải ngày chỉ định (Tích hợp xử lý thuật toán tối ưu trên SQL Data Constraint để tránh lỗi nhân đôi doanh số hợp đồng).

## 🛠 Công Nghệ Sử Dụng
- **Front-end:** HTML & Vanilla CSS, JavaScript (JSP Pages), Fonts Inter
- **Back-end:** Java Servlet / JSP chạy trên máy chủ Apache Tomcat (Java EE Engine).
- **Database:** PostgreSQL (Mô hình kết nối qua cấu trúc JDBC thuần túy).
- **Kiến trúc Thiết kế:** Mô hình MVC (Model - View - Controller), Tổ chức file theo cấu trúc 3 lớp tiêu chuẩn Web Layer -> DAO Layer -> Model Object (Entities).

## 📁 Cấu Trúc Dự Án
```text
PTTKHT - Car Rental System/
├── src/java/
│   ├── dao/             # Tầng Data Access Objects (Tương tác Database)
│   │   ├── CarDAO.java
│   │   ├── ContractDAO.java
│   │   └── DAO.java     # Config Cổng kết nối Postgres
│   └── model/           # Tầng Model Entities
│       ├── Car.java
│       ├── Contract.java
│       └── Member.java
├── web/                 # Tầng View (Giao diện JSP, CSS, HTML, JS)
│   ├── WEB-INF/         # Chứa thư viện JDBC và class đã biên dịch (.class)
│   ├── login.jsp        
│   ├── managerHome.jsp  # Trang chủ của Role Manager
│   ├── salesStaffHome.jsp # Trang chủ của Role Sales 
│   ├── searchFreeCar.jsp  # Core flow 1: Quét xe còn trống
│   ├── bookCar.jsp      # Core flow 2: Tạo hợp đồng
│   ├── deposit.jsp      # Core flow 3: Thanh toán cọc
│   ├── manageOrders.jsp # Core flow 4: Xem danh sách Order
│   └── contractDetail.jsp # Core Flow 5: Hoá đơn Invoice
├── mock_data.sql        # [QUAN TRỌNG] Script Khởi tạo & Mock data Test DB 
└── build.xml            # Cấu hình biên dịch NetBeans (Ant)
```

## 📸 Demo Giao Diện Sản Phẩm

<table align="center">
  <tr>
    <td align="center" width="33%">
      <img src="https://github.com/user-attachments/assets/1f5f2f90-6ea6-4422-9849-bf2ba01eacf1" style="max-width:100%;"><br>
      <sub><b>Trang Chủ</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="https://github.com/user-attachments/assets/782ff961-2343-41b7-a90c-4d45f15f37ed" style="max-width:100%;"><br>
      <sub><b>Giao Diện Tìm Xe</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="https://github.com/user-attachments/assets/5e427fe1-4779-465c-bddc-e901c948b7a0" style="max-width:100%;"><br>
      <sub><b>Sửa Thông Tin Xe</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d058243a-600a-4749-90e1-0cc0ea3159a7" style="max-width:100%;"><br>
      <sub><b>Giao Diện Đặt Xe</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/119c1af8-c0cf-4a24-8b22-ac3c05fd882f" style="max-width:100%;"><br>
      <sub><b>Xác Nhận Đặt Xe</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/45e79a11-1adf-43cc-be2b-af651a1136e" style="max-width:100%;"><br>
      <sub><b>Thống Kê Xe</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/e573c003-e379-4ee6-a535-12df7dfe3f1c" style="max-width:100%;"><br>
      <sub><b>Chi Tiết Doanh Thu</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/e0349b6a-8155-4ac5-9164-796d006b52f6" style="max-width:100%;"><br>
      <sub><b>Quản Lý Hợp Đồng</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/f4793914-6f7d-4e0d-9239-5b84e8818852" style="max-width:100%;"><br>
      <sub><b>Chi Tiết Hợp Đồng</b></sub>
    </td>
  </tr>
</table>

---

## 📖 Hướng Dẫn Cài Đặt & Chạy Dự Án

### Yêu Cầu Môi Trường:
- **Ngôn ngữ:** JDK 8 (Hoặc mới hơn như JDK 17/21).
- **IDE / Trình soạn thảo:** NetBeans hoặc VS Code (Có cài Extension Java).
- **Web Server:** Khuyên dùng bản tải về của `Apache Tomcat 9.0.x` hoặc mã cao hơn.
- **Cơ sở dữ liệu:** PostgreSQL (Kết hợp sử dụng phần mềm quản trị pgAdmin 4 hoặc DBeaver).

### Bước 1: Khởi Tạo Database (PostgresSQL)
1. Mở phần mềm quản trị PostgresSQL và Add Name một CSDL trống mang tên tỳ ý (đề xuất: `car_rental_system`).
2. Mở file `mock_data.sql` nằm ngay tại thư mục gốc của project (Bằng trình soạn tắt hoặc IDE). Copy toàn bộ nội dung SQL Command.
3. Chạy (Execute Script) khối lệnh vừa Copy vào trong cấu trúc Database vừa tạo.
4. *Bản Script tự động này bao phủ từ việc Create Schema, gắp liên kết (Foreign-key Constraint), và Insert sẵn hơn 10 Bản Ghi Model Xe và 4 Bản ghi Hợp Đồng mẫu thông minh.*

### Bước 2: Config DB Connect (`DAO.java`)
Nếu PostgreSQL của bạn dùng Port **5432** mặc định và User đăng ký là **postgres**, bạn tìm đến file sau: `src/java/dao/DAO.java` ra và cập nhật chuỗi kết nối sau:
```java
// Sửa địa chỉ DB
String dbUrl = "jdbc:postgresql://localhost:5432/car_rental_system";

// Sửa mật khẩu tương ứng với cấu hình máy Postgres cài máy tính của bạn
// Note: Mặc định ở source hiện tại đang set là "1112" và Port là "5433" nên hãy sửa lại.
Con = DriverManager.getConnection(dbUrl, "postgres", "matkhaucualaban"); 
```

### Bước 3A: Chạy bằng NetBeans
1. Start NetBeans -> **Open Project** -> Chọn folder Repository.
2. Tại cây cấu trúc System ở cột trái, nhấp chuột phải vào tên project -> Chọn **Clean and Build**.
3. Bấm Nút Tròn Xanh **Run Project**. Trình duyệt sẽ mở sẵn một host Local như: `http://localhost:8080/ProjectName/login.jsp`.

### Bước 3B: Chạy bằng Visual Studio Code
1. Cài đặt các **VS Code Extensions**: *Extension Pack for Java (Microsoft)* và *Community Server Connectors (Red Hat)*.
2. Biên dịch source code sang Class và dồn cục vào Package `/web/WEB-INF/classes` bằng lệnh (Gõ vào VS Code Terminal trong khi đang ở thư mục gốc Project):
   ```bash
   mkdir -p "web/WEB-INF/classes" && javac -d "web/WEB-INF/classes" -cp "lib/*:src/java:." src/java/model/*.java src/java/dao/*.java
   ```
3. Mở tab biểu tượng **SERVERS** bên tay trái VS Code -> Import *Tomcat 9* từ máy tính nếu chưa có.
4. Nhấn chuột phải vào thẻ Tomcat -> **Add Deployment** -> Lần này không chọn Root Folder mà bắt buộc phải click vào đường dẫn tên Thư mục `web` của Repo.
5. Click **Start / Run**.

### 🔐 Tài Khoản Demo Data Cấp Sẵn
Sử dụng các acc sau để test Full Tính năng web:
* **Account Sales (Bộ quyền 100% Core Booking, Deposit, Manage Orders):** `sales1` - Mật khẩu: `123456`
* **Account Manager (Giống thẻ trên cộng thêm Quản lý xe gốc, Phân kỳ Statistics):** `manager1` - Mật khẩu: `123456`
