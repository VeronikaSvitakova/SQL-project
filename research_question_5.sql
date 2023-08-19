/**
 * Má výška HDP vliv na změny ve mzdách a cenách potravin?
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
**/

-- meziroční nárůst HDP
CREATE TABLE t_gdp_percent_growth AS
SELECT final_table.payroll_year,
	final_table.payroll_year + 1 AS prev_year,
	round((final_table.gdp - second_table.gdp)/second_table.gdp *100, 2) AS GDP_growth
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
JOIN t_veronika_svitakova_project_sql_primary_final_1 AS second_table
	ON final_table.payroll_year = second_table.payroll_year + 1
GROUP BY final_table.payroll_year;

-- zobrazení meziročního růstu cen potravin, HDP a mezd v jednotlivých odvětvích (detailní výsledky)

SELECT a.payroll_year AS date,
		a.branch,
		a.percent_growth AS payroll_growth,
		b.category_name AS food,
		b.percent_price_growth,
		c.GDP_growth
FROM t_yearly_payroll_increase AS a
JOIN t_yearly_price_increase AS b
	ON a.payroll_year = b.`date`
JOIN t_gdp_percent_growth  AS c
	ON a.payroll_year = c.payroll_year
GROUP BY a.payroll_year, a.branch, b.category_name
ORDER BY a.payroll_year;


-- srovnání meziročního průměrného růstu mezd ze všech odvětví, meziročního růstu HDP a meziročního průměrného růstu cen všech potravin v jednotlivých letech 


SELECT a.payroll_year,
		round(avg(a.percent_growth), 2) AS average_payroll_growth,
		round(avg(b.percent_price_growth), 2) AS average_price_growth,
		c.GDP_growth
FROM t_yearly_payroll_increase AS a
JOIN t_gdp_percent_growth  AS c
	ON a.payroll_year = c.payroll_year
JOIN t_yearly_price_increase AS b
	ON b.date = a.payroll_year
GROUP BY a.payroll_year
ORDER BY a.payroll_year;
