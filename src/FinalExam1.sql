-- Create primary entity first

CREATE TABLE sinhvien (
	ID CHAR(8) PRIMARY KEY,
	ten VARCHAR2(15),
	ho VARCHAR2(15)
);

-- sinhvien constraints
ALTER TABLE sinhvien DROP CONSTRAINT ck_id;
ALTER TABLE sinhvien ADD CONSTRAINTS ck_id
CHECK (REGEXP_LIKE(ID, '^B\d{7}'))
-- sinhvien insert
INSERT INTO sinhvien VALUES ('B2005638', 'Tuyền', 'Lê Ngọc');
INSERT INTO sinhvien VALUES ('B2016704', 'Khanh', 'Trần Nguyễn Tường');
INSERT INTO sinhvien VALUES ('B2012598', 'Kiệt', 'Nguyễn Anh');
INSERT INTO sinhvien VALUES ('B2010786', 'Thuận', 'Trần Lê');
INSERT INTO sinhvien VALUES ('B2010641', 'Trúc', 'Nguyễn Thị Thanh');
INSERT INTO sinhvien VALUES ('B2010754', 'Như', 'Bùi Thị Thảo Như');
INSERT INTO sinhvien VALUES ('B2010500', 'Châu', 'Trần Nguyễn Liên');
INSERT INTO sinhvien VALUES ('B2015052', 'Trọng', 'Nguyễn Hoàng');
INSERT INTO sinhvien VALUES ('B2005718', 'Khải', 'Huỳnh Văn');
INSERT INTO sinhvien VALUES ('B2014748', 'Khang', 'Lâm Hoàng');
ALTER TABLE sinhvien MODIFY ho VARCHAR2(50);

CREATE TABLE nganh (
	ID INT PRIMARY KEY,
	ten_nganh VARCHAR2(50)
);

-- nganh insert
INSERT INTO nganh VALUES (1, 'Công nghệ kỹ thuật hóa học - CTCLC');
INSERT INTO nganh VALUES (2, 'Công nghệ sinh học - CTTT');
INSERT INTO nganh VALUES (3, 'Công nghệ thông tin - CTCLC');

CREATE TABLE loai_diem(
	ID INT PRIMARY KEY,
	ten_loai VARCHAR2(20)
);

INSERT INTO loai_diem VALUES (1, 'Điểm thi');
INSERT INTO loai_diem VALUES (2, 'Điểm học bạ');

CREATE TABLE trung_tuyen (
    mssv CHAR(8),
    ma_nganh INT,
    ma_loai_diem INT,
    diem FLOAT,
    FOREIGN KEY(mssv) REFERENCES sinhvien(id),
    FOREIGN KEY (ma_nganh) REFERENCES nganh(id),
    FOREIGN KEY (ma_loai_diem) REFERENCES loai_diem(id),
    PRIMARY KEY (mssv, ma_nganh)
);

ALTER TABLE trung_tuyen ADD CONSTRAINT ck_diem CHECK (diem >= 0 AND diem <= 30);

INSERT INTO trung_tuyen VALUES ('B2016704', 1, 1, 23.45);
INSERT INTO trung_tuyen VALUES ('B2012598', 2, 1, 25.70);
INSERT INTO trung_tuyen VALUES ('B2010786', 2, 1, 24.70);
INSERT INTO trung_tuyen VALUES ('B2010641', 2, 1, 25.45);
INSERT INTO trung_tuyen VALUES ('B2010754', 2, 1, 23.80);
INSERT INTO trung_tuyen VALUES ('B2010500', 2, 1, 22.50);
INSERT INTO trung_tuyen VALUES ('B2015052', 2, 1, 20.45);
INSERT INTO trung_tuyen VALUES ('B2005718', 3, 2, 26.80);
INSERT INTO trung_tuyen VALUES ('B2014748', 3, 1, 26.40);

SELECT mssv FROM trung_tuyen WHERE ma_nganh = 3 AND diem = 26.8 AND ROWNUM <= 1;

CREATE OR REPLACE FUNCTION fun_sinh_vien_cao_diem_nhat
    RETURN VARCHAR
IS
    var_ma_nganh_cntt nganh.id%TYPE;
    var_diem_cao_nhat trung_tuyen.diem%TYPE;
    var_mssv sinhvien.id%TYPE;
    var_ho sinhvien.ho%TYPE;
    var_ten sinhvien.ten%TYPE;
BEGIN
    SELECT id INTO var_ma_nganh_cntt FROM nganh WHERE ten_nganh = 'Công nghệ thông tin - CTCLC';
    SELECT MAX(diem) INTO var_diem_cao_nhat FROM trung_tuyen WHERE ma_nganh = var_ma_nganh_cntt;
    SELECT id, ho, ten INTO var_mssv, var_ho, var_ten
    FROM sinhvien sv
    INNER JOIN trung_tuyen tt ON tt.mssv = sv.id
    WHERE tt.ma_nganh = var_ma_nganh_cntt AND diem = var_diem_cao_nhat AND ROWNUM <= 1;
    RETURN var_mssv || ' - ' || var_ho || ' ' || var_ten;
END;

SELECT fun_sinh_vien_cao_diem_nhat() FROM dual;

CREATE OR REPLACE PROCEDURE pro_cap_nhat_nganh_trung_tuyen
    (par_mssv IN sinhvien.id%TYPE, par_ma_nganh nganh.id%TYPE)
IS
BEGIN
    UPDATE trung_tuyen SET ma_nganh = par_ma_nganh WHERE mssv = par_mssv;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;

CALL pro_cap_nhat_nganh_trung_tuyen('B2005638', 3);

-- do nothing athough error -> so cool. 
CALL pro_cap_nhat_nganh_trung_tuyen('B2005638', 4);

-- trung_tuyen report
SELECT mssv, ho, ten, ten_nganh, ten_loai as loai_diem, diem FROM
trung_tuyen tt INNER JOIN sinhvien sv ON sv.id = tt.mssv
INNER JOIN nganh ON nganh.id = tt.ma_nganh
INNER JOIN loai_diem ld ON ld.id = tt.ma_loai_diem;
