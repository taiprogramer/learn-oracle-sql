-- PL/SQL - Proceduce Language
-- Anonymous Block

-- Variables
-- Enable console
SET SERVEROUTPUT ON;
DECLARE
	total_sales NUMBER(15, 2);
	emp_id VARCHAR2(9);
	company_number NUMBER DEFAULT 10
BEGIN
	total_sales := 350000;
	emp_id := 3;
	-- Like console.log in Javascript
	DBMS_OUTPUT.put_line('Employee ' || emp_id || ', sold total product value: ' || total_sales);
END;

-- Get user input in SQL Developer
-- if typeof (this) == string -> 'taiprogramer'
DECLARE 
	ten VARCHAR2(10);
BEGIN
	ten := &Nhap_ten_cua_ban;
	DBMS_OUTPUT.put_line('Xin chao, ' || ten || '. Are you American?');
END;


-- More about datatypes
DECLARE
	-- vEname type is the same type with last_name type
	-- similiar for all
	vEname employees.last_name%TYPE;
	vSalary employees.salary%TYPE;
BEGIN
	SELECT last_name, salary INTO vEname, vSalary
	FROM employees
	WHERE employee_id = 100;
	
	DBMS_OUTPUT.put_line('Name: ' || vEname || '.Salary: ' || vSalary);
END;

-- Flow control :: Conditinal
DECLARE
	vEname employees.first_name%TYPE;
BEGIN
	SELECT first_name INTO vEname
	FROM employees
	WHERE employee_id = 120;
	
	IF vEname = 'Matthew' THEN
		DBMS_OUTPUT.put_line('Hi, ' || vEname);
	ELSE
		DBMS_OUTPUT.put_line('Hello, ' || vEname);
	END IF;
END;

-- Flow control :: Switch case
DECLARE
	vArea VARCHAR2(20);
BEGIN
	SELECT region_id INTO vArea
	FROM countries
	WHERE country_id = 'CA';
	
	CASE vArea
		WHEN 1 THEN vArea := 'Europe';
		WHEN 2 THEN vArea := 'America';
		WHEN 3 THEN vArea := 'Asia';
		ELSE vArea := 'Other';
	END CASE;
	DBMS_OUTPUT.put_line('The Area is ' || vArea);
END;

-- Loops
DECLARE
	counter NUMBER;
BEGIN
	FOR counter IN 1..10
	LOOP
		DBMS_OUTPUT.put(counter || '. Mot the he rong tuech.');
		DBMS_OUTPUT.new_line;
	END LOOP;
	
	DBMS_OUTPUT.put('Written by taiprogramer');
	DBMS_OUTPUT.new_line;
	
	FOR counter IN REVERSE 1..10
	LOOP
		DBMS_OUTPUT.put(counter || '. Mot the he rong tuech.');
		DBMS_OUTPUT.new_line;
	END LOOP;
	
	DBMS_OUTPUT.put('Written by taiprogramer');
	DBMS_OUTPUT.new_line;
END;
