/*
*Která kategorie potravin zdražuje nejpomaleji 
*(je u ní nejnižší percentuální meziroční nárůst)?
*/

SELECT category_code, 
	category_name,
	average_price,
	date
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
GROUP BY date ASC, category_code;
;


SELECT final_table.*,
	second_table.date +1 AS prev_year,
	round((final_table.average_price - second_table.average_price)/second_table.average_price*100) AS percent_price_growth
FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
JOIN t_veronika_svitakova_project_sql_primary_final_1 AS second_table
	ON final_table.category_code = second_table.category_code
	AND final_table.date = second_table.date + 1
GROUP BY date, category_code
ORDER BY date, category_code  ASC;

-- pomocná tabulka 

CREATE TABLE t_yearly_price_increase AS 
	SELECT final_table.date,
		final_table.category_code,
		final_table.category_name,
		final_table.average_price,
	second_table.date +1 AS prev_year,
	round((final_table.average_price - second_table.average_price)/second_table.average_price*100) AS percent_price_growth
	FROM t_veronika_svitakova_project_sql_primary_final_1 AS final_table
	JOIN t_veronika_svitakova_project_sql_primary_final_1 AS second_table
		ON final_table.category_code = second_table.category_code
		AND final_table.date = second_table.date + 1
	GROUP BY date, category_code
	ORDER BY date, category_code ASC;

	
SELECT category_code,
	category_name,
	date,
	percent_price_growth
FROM t_yearly_price_increase
GROUP BY category_code, date
ORDER BY percent_price_growth;
