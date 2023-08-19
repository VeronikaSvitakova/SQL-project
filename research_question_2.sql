/*
*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a 
*poslední srovnatelné období v dostupných datech cen a mezd?
*/

SELECT DISTINCT category_code, category_name, price
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
GROUP BY category_code;

-- 114201 - mléko
-- 111301 chléb



SELECT category_code, 
		category_name, 
		average_price,
		min(date) AS first_date, -- 2006
		max(date) AS last_date   -- 2018
FROM v_veronika_svitakova_project_sql_primary_final_1 AS final_table
WHERE category_code IN (114201,111301)
GROUP BY category_code;


SELECT payroll_year,
		value_of_payroll,
		industry_branch_code,
		branch
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
WHERE payroll_year IN(2006, 2018)
GROUP BY industry_branch_code, payroll_year
ORDER BY payroll_year;

-- výsledný dotaz na množství mléka a chleba

SELECT  category_code,
		category_name, 
		average_price,
		`date`,
		payroll_year,
		value_of_payroll,
		industry_branch_code,
		branch,
		round(value_of_payroll/average_price, 2) AS amount
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
WHERE category_code IN (114201, 111301)
	AND payroll_year IN (2006, 2018)
GROUP BY payroll_year, industry_branch_code, category_code;
				
