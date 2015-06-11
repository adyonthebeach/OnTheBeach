USE [OnTheBeach]
GO
SELECT e.id employee_id,
	   e.name,
	   r.name role,
	   CONVERT(DECIMAL(10,2), annual_amount / conversion_factor) AS salary_GBP
FROM employees e
	INNER JOIN roles r	ON	e.role_id = r.id
	INNER JOIN Salaries s	ON	e.id = s.employee_id
	INNER JOIN Currencies c	ON	s.currency = c.id