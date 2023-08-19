-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 
SELECT price_tab.`date`,
	price_tab.category_name,
	price_tab.percent_price_growth,
	payroll_tab.branch,
	payroll_tab.percent_growth,
	CASE WHEN (price_tab.percent_price_growth - payroll_tab.percent_growth) >10 
	THEN (price_tab.percent_price_growth - payroll_tab.percent_growth)
	ELSE '--'
	END AS differences
FROM t_yearly_payroll_increase AS payroll_tab
JOIN t_yearly_price_increase  AS price_tab
	ON payroll_tab.payroll_year = price_tab.date
WHERE (price_tab.percent_price_growth - payroll_tab.percent_growth) > 10
ORDER BY differences DESC;








