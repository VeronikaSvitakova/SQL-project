/*
 * Vytvoření finální tabulky t_{jmeno}_{prijmeni}_project_SQL_primary_final pro CZ
 */


-- pomocná tabulka k cenám
CREATE OR REPLACE TABLE t_veronika_svitakova_czechia_price_table AS
	SELECT
	cp.*,
	cpc.name AS category_name,
	cr.name AS cz_region,
	year(cp.date_from),
	cp.category_code AS category,
	cp.region_code AS region,
	round(avg (cp.value), 2) AS average_value
	FROM czechia_price cp
	JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
	JOIN czechia_region cr
		ON cp.region_code = cr.code
	GROUP BY year(cp.date_from), cp.category_code, cp.region_code
	ORDER BY year(cp.date_from); 
			
 -- pomocná tabulka k příjmům
CREATE OR REPLACE TABLE t_veronika_svitakova_payroll_table AS
	SELECT cp.*,
		cpib.name AS branch,
		cpvt.name AS type,
		e.GDP
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib
		ON cp.industry_branch_code = cpib.code
	JOIN czechia_payroll_value_type cpvt
		ON cp.value_type_code= cpvt.code
		AND cpvt.code = 5958
	JOIN economies e
		ON e.`year`= cp.payroll_year
		AND e.country = 'Czech republic'
	GROUP BY cp.industry_branch_code, cp.payroll_year
	ORDER BY cp.payroll_year ASC;

-- spojení tabulek do finální podoby

CREATE OR REPLACE TABLE t_veronika_svitakova_project_SQL_primary_final_1 AS
	SELECT payroll_table.industry_branch_code,
		payroll_table.branch,
		payroll_table.payroll_year,
		payroll_table.`type`,
		payroll_table.value AS value_of_payroll,
		price_table.category_code,
		price_table.category_name,
		year(price_table.date_from)AS date,
		price_table.value AS price,
		price_table.average_value AS average_price,
		price_table.region_code,
		price_table.cz_region,
		payroll_table.GDP
	FROM t_veronika_svitakova_payroll_table AS payroll_table
	JOIN t_veronika_svitakova_czechia_price_table AS price_table
		ON payroll_table.payroll_year = year(price_table.date_from)
	ORDER BY industry_branch_code, payroll_year, region_code
	;

SELECT*
FROM t_veronika_svitakova_project_sql_primary_final_1 tvspspf;
-- vytvoření pohledu primární tabulky

CREATE OR REPLACE VIEW v_veronika_svitakova_project_SQL_primary_final AS
	SELECT payroll_table.industry_branch_code,
		payroll_table.branch,
		payroll_table.payroll_year,
		payroll_table.`type`,
		payroll_table.value AS value_of_payroll,
		price_table.category_code,
		price_table.category_name,
		year(price_table.date_from)AS date,
		price_table.value AS price,
		price_table.average_value AS average_price,
		price_table.region_code,
		price_table.cz_region,
		payroll_table.GDP
	FROM t_veronika_svitakova_payroll_table AS payroll_table
	JOIN t_veronika_svitakova_czechia_price_table AS price_table
		ON payroll_table.payroll_year = year(price_table.date_from)
	ORDER BY industry_branch_code, payroll_year, region_code
	;
	
/*
 * Vytvoření tabulky dalších evropských států (HDP, GINI koeficient, populace) 2006 - 2018
 * t_{jmeno}_{prijmeni}_project_SQL_secondary_final
 */

CREATE OR REPLACE TABLE t_veronika_svitakova_project_SQL_secondary_final AS
	SELECT c.country,
		c.population,
		c.continent,
		e.GDP,
		e.year,
		e.gini
	FROM countries c
	JOIN economies e
		ON c.country = e.country
		AND c.continent = 'Europe'
		AND e.year BETWEEN 2006 AND 2018
	ORDER BY e.year ASC, c.country ASC;

