SELECT 
	location, 
	date, 
	new_cases,
	total_deaths,
	total_cases,
	population, 
	aged_65_older,
	aged_70_older,
	total_vaccinations,
	CASE 
        WHEN total_cases = 0 THEN NULL  -- Avoid division by zero
        ELSE (total_deaths / NULLIF(total_cases, 0)) * 100
    END as DeathPercent,
  --Insert a column for seasons to observe seasonal variations in the data. 
	CASE 
		when month(date) in (3,4,5) then 'Spring'
		when month(date) in (6,7,8) then 'Summer'
		when month(date) in (9,10,11) then 'Fall'
		when month(date) in (12,1,2) then 'Winter'
		ELSE 'Unknown'
	END as Season
  FROM [Learning_SQL].[dbo].['owid-covid-data$']
  order by location, date
 
