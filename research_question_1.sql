/*
 * Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

SELECT payroll_year, 
	industry_branch_code,
	branch, 
	value_of_payroll
FROM t_veronika_svitakova_project_sql_primary_final_1  AS final_table
GROUP BY industry_branch_code, branch, payroll_year ASC;



SELECT 
	first_table.payroll_year, 
	first_table.industry_branch_code,
	first_table.branch,
	first_table.value_of_payroll,
	second_table.payroll_year+1 AS prev_year,
    first_table.value_of_payroll - second_table.value_of_payroll  AS value_diff,
   round((first_table.value_of_payroll - second_table.value_of_payroll)/ second_table.value_of_payroll*100, 2) AS percent_growth
FROM t_veronika_svitakova_project_sql_primary_final_1 AS first_table
JOIN t_veronika_svitakova_project_sql_primary_final_1 AS second_table
    ON first_table.industry_branch_code = second_table.industry_branch_code
    AND first_table.branch = second_table.branch
	AND first_table.payroll_year = second_table.payroll_year +1
GROUP BY industry_branch_code, branch, payroll_year ASC;


-- vytvoření doplňkové tabulky pro další výpočty ve výzkumných otázkách
CREATE TABLE t_yearly_payroll_increase AS
	SELECT 
		first_table.payroll_year, 
		first_table.industry_branch_code,
		first_table.branch,
		first_table.value_of_payroll,
		second_table.payroll_year+1 AS prev_year,
	    first_table.value_of_payroll - second_table.value_of_payroll  AS value_diff,
	   round((first_table.value_of_payroll - second_table.value_of_payroll)/ second_table.value_of_payroll*100, 2) AS percent_growth
	FROM t_veronika_svitakova_project_sql_primary_final_1 AS first_table
	JOIN t_veronika_svitakova_project_sql_primary_final_1 AS second_table
    	ON first_table.industry_branch_code = second_table.industry_branch_code
    	AND first_table.branch = second_table.branch
		AND first_table.payroll_year = second_table.payroll_year +1
	GROUP BY industry_branch_code, branch, payroll_year ASC;