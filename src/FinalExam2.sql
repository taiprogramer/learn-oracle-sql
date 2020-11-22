/* Relax with simple quotes */
/* "Do everything that makes sense." - taiprogramer */
/* "Good designer helps to prevent people from doing stupid things.
    People make mistakes, computer don't." - taiprogramer */

/* .begin table gioi_tinh */
/* Create sequence for auto increment gioi_tinh's id */
CREATE SEQUENCE bt_gioi_tinh_seq 
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE TABLE bt_gioi_tinh (
    ma INTEGER PRIMARY KEY,
    ten VARCHAR(10) NOT NULL UNIQUE
);

/* Auto increment trigger */
CREATE OR REPLACE TRIGGER bt_before_insert_on_gioi_tinh
BEFORE INSERT ON bt_gioi_tinh
FOR EACH ROW
DECLARE
BEGIN
    SELECT bt_gioi_tinh_seq.nextval INTO :new.ma FROM DUAL;
END;

/* Insert data to gioi_tinh */
INSERT INTO bt_gioi_tinh (ten) VALUES('Male');
INSERT INTO bt_gioi_tinh (ten) VALUES('Female');
INSERT INTO bt_gioi_tinh (ten) VALUES('Other');

/* .end table gioi_tinh */

/* .begin table hoc_ki */
CREATE SEQUENCE bt_hoc_ki_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE TABLE bt_hoc_ki(
    ma INTEGER PRIMARY KEY,
    ten VARCHAR(10) NOT NULL UNIQUE
);

CREATE OR REPLACE TRIGGER bt_before_insert_on_hoc_ki
BEFORE INSERT ON bt_hoc_ki
FOR EACH ROW
BEGIN
    SELECT bt_hoc_ki_seq.nextval INTO :new.ma FROM DUAL;
END;

INSERT INTO bt_hoc_ki (ten) VALUES ('Hoc ki 1');
INSERT INTO bt_hoc_ki (ten) VALUES ('Hoc ki 2');
INSERT INTO bt_hoc_ki (ten) VALUES ('Hoc ki he');
/* .end table hoc_ki */

/* .begin table hoc_phan */
CREATE TABLE bt_hoc_phan (
    ma CHAR(5) PRIMARY KEY CHECK(REGEXP_LIKE(ma, '[A-Z]{2}\d{2}[1-9]')),
    ten VARCHAR(30),
    so_tin_chi INTEGER CHECK(so_tin_chi > 0)
);

/* Fail cases */
INSERT INTO bt_hoc_phan VALUES ('TT000', 'XYZ', 1);
INSERT INTO bt_hoc_phan VALUES ('1T111', 'ABC', 2);
INSERT INTO bt_hoc_phan VALUES ('T1111', 'DEF', 3);

/* Success cases */
INSERT INTO bt_hoc_phan VALUES ('TT001', 'Chinh tri hoc', 3);
INSERT INTO bt_hoc_phan VALUES ('IT001', 'Lap trinh can ban', 3);
INSERT INTO bt_hoc_phan VALUES ('IT002', 'Kien truc may tinh', 3);
INSERT INTO bt_hoc_phan VALUES ('IT003', 'Ly thuyet do thi', 3);
/* .end table hoc_phan */

/* .begin table nam_hoc */
DROP SEQUENCE bt_nam_hoc_seq;
CREATE SEQUENCE bt_nam_hoc_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

DROP TABLE bt_nam_hoc;
CREATE TABLE bt_nam_hoc (
    ma INTEGER PRIMARY KEY,
    nam_bat_dau INTEGER CHECK (nam_bat_dau >= 1966),
    nam_ket_thuc INTEGER,
    CONSTRAINT ck_nam_hoc CHECK(nam_ket_thuc > nam_bat_dau)
);

CREATE OR REPLACE TRIGGER bt_before_insert_nam_hoc
BEFORE INSERT ON bt_nam_hoc
FOR EACH ROW
BEGIN
    SELECT bt_nam_hoc_seq.nextval INTO :new.ma FROM DUAL;
END;

/* Fail cases */
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc)
VALUES (1965, 1967);
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc)
VALUES (1967, 1967);

/* Success cases */
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc) VALUES (1966, 1967);
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc) VALUES (1968, 1969);
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc) VALUES (1970, 1971);
INSERT INTO bt_nam_hoc (nam_bat_dau, nam_ket_thuc) VALUES (1972, 1973);
/* .end table nam_hoc */

/* .begin table sinh_vien */
CREATE TABLE bt_sinh_vien (
    mssv CHAR(8) PRIMARY KEY CHECK (REGEXP_LIKE(mssv, '[A-Z]\d{6}[1-9]')),
    ho VARCHAR(30),
    ten VARCHAR(10) NOT NULL,
    nam_sinh INTEGER CHECK (nam_sinh >= 1945), 
    ma_gioi_tinh INTEGER,
    FOREIGN KEY (ma_gioi_tinh) REFERENCES bt_gioi_tinh(ma)
);

INSERT INTO bt_sinh_vien
VALUES ('B0000001', 'Trump', 'Donald', 1945, 1);

INSERT INTO bt_sinh_vien
VALUES ('B0000002', 'Zuckerburg', 'Mark', 1945, 1);

INSERT INTO bt_sinh_vien
VALUES ('B0000003', 'Ngo Dinh', 'Diem', 1945, 1);

INSERT INTO bt_sinh_vien
VALUES ('B0000004', 'Tovards', 'Linus', 1969, 1);
/* Fail cases */
INSERT INTO bt_sinh_vien
VALUES ('B0000000', 'Nguyen Van', 'Thieu', 1945, 1);

INSERT INTO bt_sinh_vien
VALUES ('00000009', 'Nguyen Van', 'Thieu', 1945, 1);
/* .end table sinh_vien */

/* .begin table bang_diem_sinh_viten */
CREATE TABLE bt_bang_diem_sinh_vien (
    mssv CHAR(8),
    ma_hoc_phan CHAR(5),
    diem NUMBER(4, 2),
    ma_hoc_ki INTEGER,
    ma_nam_hoc INTEGER,
    FOREIGN KEY (mssv) REFERENCES bt_sinh_vien(mssv),
    FOREIGN KEY (ma_hoc_phan) REFERENCES bt_hoc_phan(ma),
    FOREIGN KEY (ma_hoc_ki) REFERENCES bt_hoc_ki(ma),
    FOREIGN KEY (ma_nam_hoc) REFERENCES bt_nam_hoc(ma),
    PRIMARY KEY (mssv, ma_hoc_phan, ma_hoc_ki, ma_nam_hoc)
);

CREATE OR REPLACE TRIGGER bt_before_insert_on_bang_diem_sinh_vien
BEFORE INSERT ON bt_bang_diem_sinh_vien
FOR EACH ROW
DECLARE
    nam_sinh_sv bt_sinh_vien.nam_sinh%TYPE;
    nam_bat_dau_hoc_ki bt_nam_hoc.nam_bat_dau%TYPE;
BEGIN
    /* Make sure student old enough. */
    SELECT nam_bat_dau INTO nam_bat_dau_hoc_ki FROM bt_nam_hoc
    WHERE ma = :new.ma_nam_hoc;
    SELECT nam_sinh INTO nam_sinh_sv FROM bt_sinh_vien
    WHERE mssv = :new.mssv;
    IF (nam_bat_dau_hoc_ki - 18) < nam_sinh_sv THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student too young so input is not valid.');
    END IF;
END;

/* Donald J Trump */
INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000001', 'TT001', 10.0, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000001', 'IT001', 10.0, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000001', 'IT002', 10.0, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000001', 'IT003', 10.0, 1, 3);

/* Ngo Dinh Diem */
INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000003', 'TT001', 9.75, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000003', 'IT001', 7.5, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000003', 'IT002', 8.75, 1, 3);

/* Mark Zuckerberg */
INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000002', 'IT001', 10, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000002', 'IT002', 8.25, 1, 3);

INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000002', 'IT003', 9.5, 1, 3);

/* Fail cases */
INSERT INTO bt_bang_diem_sinh_vien
VALUES ('B0000004', 'IT001', 10, 1, 3);

/* Summary report */
SELECT sv.ten, diem, hp.ten AS Mon_hoc, hk.ten, nh.nam_bat_dau
FROM bt_bang_diem_sinh_vien bd INNER JOIN bt_sinh_vien sv
ON sv.mssv = bd.mssv INNER JOIN bt_hoc_phan hp
ON hp.ma = bd.ma_hoc_phan JOIN bt_nam_hoc nh
ON nh.ma = bd.ma_nam_hoc JOIN bt_hoc_ki hk
ON hk.ma = bd.ma_hoc_ki;
/* .end table bang_diem_sinh_vien */

/* .begin proceduces */
CREATE OR REPLACE PROCEDURE bt_cap_nhat_diem_sinh_vien(
    p_mssv IN bt_sinh_vien.mssv%TYPE,
    p_ma_hoc_phan IN bt_hoc_phan.ma%TYPE,
    p_ma_nam_hoc IN bt_nam_hoc.ma%TYPE,
    p_ma_hoc_ki IN bt_hoc_ki.ma%TYPE,
    p_diem IN bt_bang_diem_sinh_vien.diem%TYPE)
IS
BEGIN
    UPDATE bt_bang_diem_sinh_vien SET diem = p_diem
    WHERE ma_hoc_phan = p_ma_hoc_phan AND ma_nam_hoc = p_ma_nam_hoc
    AND ma_hoc_ki = p_ma_hoc_ki;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Invalid input.');
END;

CALL bt_cap_nhat_diem_sinh_vien('B0000001', 'IT003', 3, 1, 9.9);

CREATE OR REPLACE PROCEDURE bt_them_sinh_vien(
    p_mssv IN bt_sinh_vien.mssv%TYPE,
    p_ho IN bt_sinh_vien.ho%TYPE,
    p_ten IN bt_sinh_vien.ten%TYPE,
    p_nam_sinh IN bt_sinh_vien.nam_sinh%TYPE,
    p_ma_gioi_tinh IN bt_sinh_vien.ma_gioi_tinh%TYPE)
IS
BEGIN
    INSERT INTO bt_sinh_vien VALUES (p_mssv, p_ho, p_ten, p_nam_sinh, p_ma_gioi_tinh);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('sys: invalid data -> check your p_mssv or p_ma_gioi_tinh.');
END;

CALL bt_them_sinh_vien('B0000005', 'Stallman', 'Richard', 1953, 1);
/* .end proceduces */

/* .begin functions */
CREATE OR REPLACE FUNCTION bt_diem_trung_binh(
    p_mssv IN bt_sinh_vien.mssv%TYPE,
    p_ma_nam_hoc IN bt_nam_hoc.ma%TYPE,
    p_ma_hoc_ki IN bt_hoc_ki.ma%TYPE
)
RETURN bt_bang_diem_sinh_vien.diem%TYPE
IS
    diem_tb bt_bang_diem_sinh_vien.diem%TYPE;
BEGIN
    SELECT sum(diem * hp.so_tin_chi) / sum(hp.so_tin_chi) INTO diem_tb FROM bt_bang_diem_sinh_vien bd
    INNER JOIN bt_hoc_phan hp
    ON bd.ma_hoc_phan = hp.ma
    WHERE mssv = p_mssv AND ma_nam_hoc = p_ma_nam_hoc AND ma_hoc_ki = p_ma_hoc_ki;
    RETURN diem_tb;
END;

SELECT bt_diem_trung_binh('B0000001', 3, 1) AS DTB FROM DUAL;

CREATE OR REPLACE FUNCTION bt_diem_so_sang_chu(
    diem_tb IN bt_bang_diem_sinh_vien.diem%TYPE
)
RETURN VARCHAR
IS
    diem_chu VARCHAR(2);
BEGIN
    IF diem_tb > 9 THEN diem_chu := 'A+';
    ELSIF diem_tb > 8 THEN diem_chu := 'A';
    ELSIF diem_tb > 7 THEN diem_chu := 'B+';
    ELSIF diem_tb > 6 THEN diem_chu := 'B';
    ELSIF diem_tb > 4 THEN diem_chu := 'C';
    ELSE diem_chu := 'F';
    END IF;
    RETURN diem_chu;
END;

SELECT bt_diem_so_sang_chu(9.98) Diem_chu FROM DUAL;
/* .end functions */

/* .begin grant user to access to db, functions, triggers */

/* .mode Private */
 
/* .end grant user to access to db, functions, triggers */