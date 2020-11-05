-- Check constraint in Oracle SQL

-- MaNXB: 4 characters
-- f_char from A to Z
-- s_char is 9
-- t_char from 1 to 9
-- last_char from 0 to 9
CREATE TABLE NhaXB (
	MaNXB CHAR(4) NOT NULL CONSTRAINT PK_NXB PRIMARY KEY
	CHECK (MaNXB IN ('1389', '0736', '0877', '1662', '1756')
		OR regexp_like(MaNXB, '[A-Z]9[1-9]\d')),
	TenNXB VARCHAR2(40) NULL,
	ThPho VARCHAR2(20) NULL,
	QGia VARCHAR2(30) DEFAULT 'VietNam' NULL);
	
-- error because violate check constraints (MaNXB)
INSERT INTO NhaXB (MaNXB, TenNXB, ThPho) VALUES ('9980', 'NXB Van Hoa 1', 'TP HCM');
-- success
INSERT INTO NhaXB (MaNXB, TenNXB, ThPho) VALUES ('1389', 'NXB Van Hoa 1', 'TP HCM');
-- create 'baohiem' user with password is 'baohiem'
CREATE USER baohiem IDENTIFIED BY baohiem DEFAULT TABLESPACE USERS QUOTA 2M ON USERS;
GRANT CREATE SESSION, CREATE TABLE TO baohiem;

-- begin terminal
-- imp userid=baohiem/baohiem@orcl file="baohiem.dmp" fromuser=baohiem touser=baohiem
-- end

-- With baohiem user do
SELECT * FROM donvi;

-- SELECT * FROM user_indexes;
ALTER TABLE donvi ADD CONSTRAINT pk_dv PRIMARY KEY (madv)
	ADD CONSTRAINT uk_tendv UNIQUE (tendv);
	
ALTER TABLE donvi	ADD CHECK (regexp_like(tel, '^38\d{6}'));

ALTER TABLE kh ADD CONSTRAINT pk_kh PRIMARY KEY (makh)
	ADD CONSTRAINT fk_dv FOREIGN KEY (madv) REFERENCES donvi(madv);
	
ALTER TABLE kh ADD CONSTRAINT ck_phai CHECK (phai IN (0,1));

ALTER TABLE loaibh ADD CONSTRAINT pk_loai PRIMARY KEY (maloai)
	ADD CONSTRAINT uk_tenloai UNIQUE (tenloai)
	ADD CONSTRAINT ck_mucphi CHECK (mucphi > 0);
	
ALTER TABLE thebh ADD PRIMARY KEY (maloai, makh, ngaybd)
	ADD FOREIGN KEY (maloai) REFERENCES loaibh(maloai)
	ADD FOREIGN KEY (makh) REFERENCES kh(makh);
	
ALTER TABLE thebh ADD CONSTRAINT ck_thoihan CHECK (thoihan > 0);

SELECT * FROM user_indexes;
-- end











