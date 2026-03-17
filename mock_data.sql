-- =========================================================================================
-- PHẦN 1: XÓA DỮ LIỆU CŨ VÀ RESET ID ĐỂ TRÁNH TRÙNG LẶP (Chạy nhiều lần không bị lỗi)
-- =========================================================================================
TRUNCATE TABLE 
    tblMember, tblCustomer, tblCar, tblContract, 
    tblContractDetail, tblCollateralAsset, tblAssetDetail, 
    tblCarError, tblCarErrorDetail
RESTART IDENTITY CASCADE;

DROP TABLE IF EXISTS tblCarErrorDetail CASCADE;
DROP TABLE IF EXISTS tblCarError CASCADE;
DROP TABLE IF EXISTS tblAssetDetail CASCADE;
DROP TABLE IF EXISTS tblCollateralAsset CASCADE;
DROP TABLE IF EXISTS tblContractDetail CASCADE;
DROP TABLE IF EXISTS tblContract CASCADE;
DROP TABLE IF EXISTS tblCar CASCADE;
DROP TABLE IF EXISTS tblCustomer CASCADE;
DROP TABLE IF EXISTS tblMember CASCADE;

-- =========================================================================================
-- PHẦN 2: TẠO CẤU TRÚC CÁC BẢNG (TABLES) THEO ĐÚNG THỨ TỰ RÀNG BUỘC (FOREIGN KEY)
-- =========================================================================================

-- Bảng 1: Bảng thành viên (Nhân viên/Quản lý)
CREATE TABLE tblMember (
    id SERIAL PRIMARY KEY,
    fullName VARCHAR(50),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phoneNumber VARCHAR(15),
    role VARCHAR(20) NOT NULL
);

-- Bảng 2: Bảng Khách hàng
CREATE TABLE tblCustomer (
    id SERIAL PRIMARY KEY,
    fullName VARCHAR(50),
    idNumber VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(50),
    address VARCHAR(100),
    phoneNumber VARCHAR(15)
);

-- Bảng 3: Bảng Xe
CREATE TABLE tblCar (
    id SERIAL PRIMARY KEY,
    carName VARCHAR(50),
    carType VARCHAR(50),
    modelYear VARCHAR(10),
    licensePlate VARCHAR(10) UNIQUE NOT NULL,
    rentalPrice FLOAT,
    color VARCHAR(50),
    description VARCHAR(255)
);

-- Bảng 4: Bảng Hợp đồng (Đã phân tích các tham số mới Booking & Deposit)
CREATE TABLE tblContract (
    id SERIAL PRIMARY KEY,
    createdDate DATE DEFAULT CURRENT_DATE,
    contractValue FLOAT DEFAULT 0,
    -- Các trường phục vụ chức năng Deposit & Booking mới code
    clientName VARCHAR(255),
    clientPhone VARCHAR(20),
    depositAmount FLOAT DEFAULT 0,
    status VARCHAR(50) DEFAULT 'Booked',
    -- Khóa Phụ trỏ tới tblMember và tblCustomer (Cho phép tblCustomerid NULL nếu khách điền form nhanh ở booking)
    tblMemberid INT NOT NULL, 
    tblCustomerid INT,
    FOREIGN KEY (tblMemberid) REFERENCES tblMember(id),
    FOREIGN KEY (tblCustomerid) REFERENCES tblCustomer(id)
);

-- Bảng 5: Bảng Chi tiết Hợp đồng
CREATE TABLE tblContractDetail (
    id SERIAL PRIMARY KEY,
    rentalStartDate DATE,
    rentalEndDate DATE,
    tblContractid INT NOT NULL,
    tblCarid INT NOT NULL,
    FOREIGN KEY (tblContractid) REFERENCES tblContract(id),
    FOREIGN KEY (tblCarid) REFERENCES tblCar(id)
);

-- Bảng 6: Bảng Tài sản đảm bảo
CREATE TABLE tblCollateralAsset (
    id SERIAL PRIMARY KEY,
    assetName VARCHAR(50),
    assetType VARCHAR(50),
    value FLOAT
);

-- Bảng 7: Chi tiết Tài sản đảm bảo
CREATE TABLE tblAssetDetail (
    id SERIAL PRIMARY KEY,
    tblContractid INT NOT NULL,
    tblAssetid INT NOT NULL,
    FOREIGN KEY (tblContractid) REFERENCES tblContract(id),
    FOREIGN KEY (tblAssetid) REFERENCES tblCollateralAsset(id)
);

-- Bảng 8: Bảng Lỗi xe
CREATE TABLE tblCarError (
    id SERIAL PRIMARY KEY,
    errorName VARCHAR(50),
    description VARCHAR(255)
);

-- Bảng 9: Chi tiết Lỗi xe
CREATE TABLE tblCarErrorDetail (
    id SERIAL PRIMARY KEY,
    tblCarErrorid INT NOT NULL,
    tblContractDetailid INT NOT NULL,
    FOREIGN KEY (tblCarErrorid) REFERENCES tblCarError(id),
    FOREIGN KEY (tblContractDetailid) REFERENCES tblContractDetail(id)
);

-- =========================================================================================
-- PHẦN 3: TẠO DỮ LIỆU CƠ BẢN (MEMBER, CUSTOMER, CARS, ERRORS, ASSETS)
-- =========================================================================================

-- 1. tblMember
INSERT INTO tblMember (fullName, username, password, email, phoneNumber, role) VALUES
('Phan Lê Huy', 'manager1', '123456', 'huyphan@manager.com', '0925683732', 'manager'),
('Nguyễn Chí Hiếu', 'sales1', '123456', 'hieunguyen@salestaff.com', '0902892981', 'salestaff'),
('Mai Thế Dương', 'manager2', '123456', 'duongmaithe@manager.com', '0852413876', 'manager' ),
('Trần Anh Dũng', 'sales2', '123456', 'dungtran@salesstaff.com', '09123876543', 'salestaff'),
('Nguyễn Bá Việt Hoàng', 'sales3', '123456', 'hoangba@salesstaff.com', '0862543678', 'salestaff');

-- 2. tblCustomer 
INSERT INTO tblCustomer (fullName, idNumber, email, phoneNumber, address) VALUES
('Đào Ngọc Đức', '038203005797', 'ducdn@gmail.com', '0915245907', 'Hà Nội'),
('Tạ Đức Minh', '039755532410', 'minhtd@gmail.com', '0835740799', 'Hải Phòng'),
('Nguyễn Đức Khải', '038005887242', 'khaind@gmail.com', '0986531287', 'Bắc Ninh'),
('Lê Thị Hương', '038199001234', 'huongle@gmail.com', '0977123456', 'Hà Nam'),
('Phạm Văn Nam', '034099112233', 'nampham@gmail.com', '0988999888', 'Nam Định');

-- 3. tblCar (10 xe đa dạng phục vụ thống kê & tìm xe trống)
INSERT INTO tblCar (carName, carType, modelYear, licensePlate, rentalPrice, color, description) VALUES
('Toyota Vios', 'Sedan', '2022', '30A-111.11', 800000, 'Trắng', 'Xe 4 chỗ tiêu chuẩn, tiết kiệm nhiên liệu'),
('Hyundai Accent', 'Sedan', '2021', '30A-222.22', 750000, 'Bạc', 'Xe 4 chỗ nhỏ gọn, phanh ABS'),
('Honda City', 'Sedan', '2023', '30A-333.33', 850000, 'Đỏ', 'Xe 4 chỗ bản RS cao cấp'),
('Mazda 3', 'Sedan', '2022', '30A-444.44', 900000, 'Xanh dương', 'Xe 4 chỗ kiểu dáng thể thao, cửa sổ trời'),
('Toyota Innova', 'SUV', '2021', '30A-555.55', 1200000, 'Bạc', 'Xe 7 chỗ gia đình rộng rãi'),
('Mitsubishi Xpander', 'MPV', '2022', '30A-666.66', 1000000, 'Đen', 'Xe 7 chỗ đa dụng, phù hợp đi tỉnh'),
('Kia Seltos', 'CUV', '2023', '30A-777.77', 1100000, 'Trắng', 'Xe 5 chỗ gầm cao, nội thất da'),
('Hyundai Santa Fe', 'SUV', '2022', '30A-888.88', 1500000, 'Đen', 'Xe 7 chỗ hạng D cao cấp'),
('Ford Everest', 'SUV', '2023', '30A-999.99', 1600000, 'Đỏ', 'Xe 7 chỗ máy dầu, 2 cầu mạnh mẽ'),
('Toyota Fortuner', 'SUV', '2021', '30A-000.00', 1400000, 'Trắng', 'Xe 7 chỗ gầm cao, vượt mọi địa hình');

-- 4. tblCarError
INSERT INTO tblCarError (errorName, description) VALUES
('Trầy xước thân xe', 'Vết xước sơn nhẹ bên ngoài thân xe'),
('Móp nhẹ', 'Vết lõm nhẹ ở cửa hoặc cản xe, không rách kim loại'),
('Lốp mòn', 'Gai lốp mòn quá vạch tiêu chuẩn'),
('Nội thất bẩn', 'Ghế hoặc sàn xe bị bẩn, có mùi hôi'),
('Đèn pha hỏng', 'Đèn pha bên trái bị cháy bóng');

-- 5. tblCollateralAsset
INSERT INTO tblCollateralAsset (assetName, assetType, value) VALUES
('Tiền mặt 5tr', 'Tiền mặt', 5000000),
('Tiền mặt 10tr', 'Tiền mặt', 10000000),
('Xe máy Honda Vision', 'Hiện vật', 30000000),
('Xe máy Honda SH', 'Hiện vật', 70000000),
('Laptop Macbook Air', 'Hiện vật', 18000000),
('Sổ hộ khẩu', 'Giấy tờ', 0);


-- =========================================================================================
-- PHẦN 4: TẠO HỢP ĐỒNG (CONTRACT) & CHI TIẾT HỢP ĐỒNG (CONTRACT DETAIL) CHO MỤC ĐÍCH TEST
-- =========================================================================================

-- Tạo 4 hợp đồng (Bao gồm dữ liệu cọc, ngày tạo, status và liên kết staff/khách hàng)
-- Hợp đồng 1: Đầu năm (Tháng 1/2026)
INSERT INTO tblContract (createdDate, contractValue, clientName, clientPhone, depositAmount, status, tblMemberid, tblCustomerid) 
VALUES ('2026-01-05', 2400000, 'Nguyễn Văn Quang', '0901234567', 1000000, 'Finished', 2, 1);

-- Hợp đồng 2: Dịp tết (Tháng 2/2026)
INSERT INTO tblContract (createdDate, contractValue, clientName, clientPhone, depositAmount, status, tblMemberid, tblCustomerid) 
VALUES ('2026-02-10', 3750000, 'Trần Châu Anh', '0912345678', 1500000, 'Finished', 4, 2);

-- Hợp đồng 3: Đang diễn ra (Tháng 3/2026)
INSERT INTO tblContract (createdDate, contractValue, clientName, clientPhone, depositAmount, status, tblMemberid, tblCustomerid) 
VALUES ('2026-03-10', 5100000, 'Lê Văn Luyện', '0923456789', 2000000, 'Deposited', 2, 3);

-- Hợp đồng 4: Lịch đặt trước (Tháng 4/2026)
INSERT INTO tblContract (createdDate, contractValue, clientName, clientPhone, depositAmount, status, tblMemberid, tblCustomerid) 
VALUES ('2026-03-15', 4400000, 'Hoàng Kim Cốt', '0934567890', 2200000, 'Booked', 5, 4);

-- Gán chi tiết xe được thuê vào từng Hợp đồng tương ứng thông qua DO Block
DO $$
DECLARE
    car_vios_id INT;
    car_accent_id INT;
    car_city_id INT;
    car_seltos_id INT;
    contract1_id INT;
    contract2_id INT;
    contract3_id INT;
    contract4_id INT;
BEGIN
    SELECT id INTO car_vios_id FROM tblCar WHERE licensePlate = '30A-111.11' LIMIT 1;
    SELECT id INTO car_accent_id FROM tblCar WHERE licensePlate = '30A-222.22' LIMIT 1;
    SELECT id INTO car_city_id FROM tblCar WHERE licensePlate = '30A-333.33' LIMIT 1;
    SELECT id INTO car_seltos_id FROM tblCar WHERE licensePlate = '30A-777.77' LIMIT 1;

    SELECT id INTO contract1_id FROM tblContract WHERE clientName = 'Nguyễn Văn Quang' LIMIT 1;
    SELECT id INTO contract2_id FROM tblContract WHERE clientName = 'Trần Châu Anh' LIMIT 1;
    SELECT id INTO contract3_id FROM tblContract WHERE clientName = 'Lê Văn Luyện' LIMIT 1;
    SELECT id INTO contract4_id FROM tblContract WHERE clientName = 'Hoàng Kim Cốt' LIMIT 1;

    -- Hợp đồng 1: Vios thuê 3 ngày tháng 1 (Ngày 10 -> Ngày 12)
    INSERT INTO tblContractDetail (tblContractid, tblCarid, rentalStartDate, rentalEndDate) 
    VALUES (contract1_id, car_vios_id, '2026-01-10', '2026-01-12');

    -- Hợp đồng 2: Accent thuê 5 ngày tháng 2 (Ngày 14 -> Ngày 18)
    INSERT INTO tblContractDetail (tblContractid, tblCarid, rentalStartDate, rentalEndDate) 
    VALUES (contract2_id, car_accent_id, '2026-02-14', '2026-02-18');

    -- Hợp đồng 3: City thuê 6 ngày tháng 3 (Ngày 15 -> Ngày 20)
    INSERT INTO tblContractDetail (tblContractid, tblCarid, rentalStartDate, rentalEndDate) 
    VALUES (contract3_id, car_city_id, '2026-03-15', '2026-03-20');

    -- Hợp đồng 4: Seltos thuê 4 ngày tháng 4 (Ngày 1 -> Ngày 4)
    INSERT INTO tblContractDetail (tblContractid, tblCarid, rentalStartDate, rentalEndDate) 
    VALUES (contract4_id, car_seltos_id, '2026-04-01', '2026-04-04');
END $$;

-- =========================================================================================
-- PHẦN 5: TẠO LIÊN KẾT TÀI SẢN ĐẢM BẢO & LỖI NẾU CÓ
-- =========================================================================================

INSERT INTO tblAssetDetail (tblContractid, tblAssetid) VALUES
((SELECT id FROM tblContract WHERE clientName = 'Nguyễn Văn Quang' LIMIT 1), 4),
((SELECT id FROM tblContract WHERE clientName = 'Trần Châu Anh' LIMIT 1), 1),
((SELECT id FROM tblContract WHERE clientName = 'Lê Văn Luyện' LIMIT 1), 3), 
((SELECT id FROM tblContract WHERE clientName = 'Hoàng Kim Cốt' LIMIT 1), 1); 

-- Giả lập Hợp đồng 1 có 1 lỗi lốp mòn
INSERT INTO tblCarErrorDetail (tblContractDetailid, tblCarErrorid) VALUES
((SELECT id FROM tblContractDetail LIMIT 1 OFFSET 0), 3);

-- =========================================================================================
-- PHẦN 6: ĐỒNG BỘ - TỰ ĐỘNG TÍNH TOÁN LẠI KHỚP CONTRACT VALUE TỪ SỐ NGÀY * GIÁ THUÊ CỦA XE
-- =========================================================================================
UPDATE tblContract t1
SET contractValue = subquery.calculated_total
FROM (
    SELECT 
        cd.tblContractid, 
        SUM((cd.rentalEndDate - cd.rentalStartDate + 1) * c.rentalPrice) as calculated_total
    FROM tblContractDetail cd
    JOIN tblCar c ON cd.tblCarid = c.id
    GROUP BY cd.tblContractid
) as subquery
WHERE t1.id = subquery.tblContractid;

-- Xong! Bạn có thể sử dụng Postgres để xem kết quả:
-- SELECT id, clientName, createdDate, contractValue FROM tblContract ORDER BY id;
