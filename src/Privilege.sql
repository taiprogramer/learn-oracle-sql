-- SYSTEM Connection
-- Create new user
CREATE USER user1 IDENTIFIED BY user1;

GRANT CREATE SESSION TO user1;
GRANT CREATE TABLE, CREATE USER, CREATE SESSION To user1 WITH ADMIN OPTION;
ALTER USER user1 DEFAULT TABLESPACE users QUOTA 2M ON users;

REVOKE CREATE TABLE FROM user1;

CREATE USER user3 IDENTIFIED BY user3 DEFAULT TABLESPACE users QUOTA 2M ON users;
GRANT CREATE SESSION TO user3;
GRANT CREATE TABLE TO user3 WITH ADMIN OPTION;

-- USER1 Connection
ALTER USER user1 IDENTIFIED BY newPassPharse;
CREATE TABLE Students (
  SID char(7) PRIMARY KEY,
  SNAME Varchar2(30)  
);

INSERT INTO Students VALUES (
  'B180000', 
  'Nguyen Van Thieu'
);

INSERT INTO Students VALUES (
  'B180001', 
  'Ngo Dinh Diem'
);

CREATE USER user2 IDENTIFIED BY user2 DEFAULT TABLESPACE users QUOTA 2M ON users;
GRANT CREATE SESSION TO user2;
GRANT CREATE TABLE TO user2 WITH ADMIN OPTION;

-- try to create table after revoked CREATE TABLE by sys
CREATE TABLE Students_2 (
  SID char(7) PRIMARY KEY,
  SNAME Varchar2(30)  
);
-- -> Can not create new table because don't have permission

GRANT SELECT, UPDATE ON students TO user2 WITH GRANT OPTION;

-- USER2 Connection
CREATE TABLE Products (
  PID char(3) PRIMARY KEY,
  PNAME Varchar(30)
);

INSERT INTO Products VALUES ('P01', 'Rau');
INSERT INTO Products VALUES ('P02', 'Thuoc');

SELECT * FROM Products;

-- try to create new table after user1 has been revoked CREATE TABLE
CREATE TABLE Products_2 (
  PID char(3) PRIMARY KEY,
  PNAME Varchar(30)
);
-- -> success

-- USER3 Connection







