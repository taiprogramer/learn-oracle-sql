-- PROCEDURE AND FUNCTION
-- Fun facts:
-- dual: is temparory table for testing
-- desc: describe table schema

-- Renew or re-create procedure
-- Procedure return nothing
CREATE OR REPLACE PROCEDURE pro_delete_emp
	(
		par_empno IN NUMBER
	)
IS
	local_var CHAR(4);
BEGIN
	DELETE FROM scott_emp WHERE empno = par_empno;
	COMMIT;
END;

-- Find someone
SELECT * FROM scott_emp WHERE empno = 7654;
-- Try to delete
EXECUTE pro_delete_emp(7654);

-- Function return something
CREATE OR REPLACE FUNCTION fun_get_dept_salary
	(
		par_deptno IN NUMBER
	)
RETURN NUMBER
IS
	local_var CHAR(4);
	res_sum NUMBER(7, 2);
BEGIN
	res_sum := 0;
	FOR emp_sal IN (
		SELECT sal FROM scott_emp WHERE deptno = par_deptno AND sal IS NOT NULL
	)
	LOOP
		res_sum := res_sum + emp_sal.sal;
	END LOOP;
	RETURN res_sum;
END;

SELECT fun_get_dept_salary(30) from dual;

SET SERVEROUTPUT ON;

DECLARE
	result NUMBER(7, 2);
BEGIN
	result := fun_get_dept_salary(30);
	DBMS_OUTPUT.put_line(result);
END;

-- Procedure with output and input
CREATE OR REPLACE PROCEDURE pro_get_pay_grade
	(
		par_jobid IN jobs.job_id%TYPE,
		par_max_salary OUT jobs.max_salary%TYPE,
		par_min_salary OUT jobs.min_salary%TYPE,
	)
IS
BEGIN
	SELECT min_salary, max_salary INTO par_min_salary, par_max_salary
	WHERE job_id = par_jobid;
	
	EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('Make sure your job_id is correct.');
        WHEN OTHERS THEN
            DBMS_OUPUT.put_line('Out of control.');
END;

-- Testing
DECLARE
	min1 jobs.min_salary%TYPE;
	max2 jobs.max_salary%TYPE;
BEGIN
	pro_get_pay_grade('&Nhap_ma_cong_viec', min1, max1);
	DBMS_OUTPUT.put_line('Min = ' || TO_CHAR(min1) || 'MAX = ' || TO_CHAR(max2));
END;
