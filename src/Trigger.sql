-- TRIGGER
-- Good for logging
-- Can use for create constraint but NOT RECOMMEND
-- Fun facts:
-- - user: return current user
-- - sysdate: return current system date (include time)
-- - dmp file can not import on Oracle Cloud

DESC scott_dept;
ALTER TABLE scott_dept ADD budget NUMBER(10);

-- select total salary of all staff\
-- group by deptno
SELECT deptno, SUM(sal) as Total_Sal
FROM scott_emp
GROUP BY (deptno);

UPDATE scott_emp SET budget = 9150
WHERE deptno = 30;

-- Create trigger for table in command mode
-- What the heck is command mode, trigger do something
-- when user USE COMMAND to change data in table
-- Usage: Check constraint
-- Notation:
-- v prefix stands for variable
CREATE OR REPLACE TRIGGER check_budget_emp
AFTER INSERT OR UPDATE OF sal, deptno ON scott_emp
DECLARE
	CURSOR dept_cur IS SELECT deptno, budget FROM scott_dept;
	v_deptno scott_dept.deptno%TYPE;
	v_budget scott_dept.budget%TYPE;
	-- total salary of department have beed paid
	v_total_sal scott_emp.sal%TYPE;
BEGIN
	OPEN dept_cur;
	LOOP
		FETCH dept_cur INTO v_deptno, v_budget;
        EXIT WHEN dept_cur%NOTFOUND;
	
		-- total salary of department have beed paid
		SELECT SUM(sal) INTO v_total_sal FROM scott_emp
		WHERE deptno = v_deptno;
		
		IF (v_budget < v_total_sal) THEN
			RAISE_APPLICATION_ERROR(-20325,
			'Total salary of department '
			|| TO_CHAR(v_deptno)
			|| ' is overbudget.');
		END IF;
	END LOOP;
	CLOSE dept_cur;
END;
-- Test above trigger
UPDATE scott_emp SET SAL = SAL + 1500 WHERE empno = 7839;

-- Create trigger for logging in row mode
-- What the heck is row mode, trigger do something
-- when table data changed no matter they use command or GUI
-- Create log_table
CREATE TABLE change_sal_emp (
	username VARCHAR(20),
	modified_time TIMESTAMP,
	empno NUMBER(4),
    old_sal NUMBER(7, 2),
    new_sal NUMBER(7, 2)
);

CREATE OR REPLACE TRIGGER store_change_sal_emp
AFTER UPDATE OF sal ON scott_emp
FOR EACH ROW
