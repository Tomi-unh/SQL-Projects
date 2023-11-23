SELECT 
	location,
	continent,
	date, 
	new_cases,
	total_deaths,
	total_cases,
	population, 
	aged_65_older,
	aged_70_older,
	total_vaccinations,

	CASE 
        when try_cast(total_cases as float) = 0 THEN NULL  -- Avoid division by zero
        else try_cast(total_deaths as float) / NULLIF((try_cast(total_cases as float)), 0) * 100
    END as DeathPercent,
  --Insert a column for seasons to observe seasonal variations in the data. 
  

	CASE 
		when month(date) in (3,4,5) then 'Spring'
		when month(date) in (6,7,8) then 'Summer'
		when month(date) in (9,10,11) then 'Fall'
		when month(date) in (12,1,2) then 'Winter'
		ELSE 'Unknown'
	END as Season,

	--Perform a rolling average on the total deaths to see the trend in the death data. The rolling 
	-- window in this case is 5 days.
	-- The rolling window is performed as a function of location and time,
	-- with location taking priority over time. 

	AVG(try_cast(total_deaths as float)) 
		over(order by location, date rows between 4 preceding and current row) 
		as rolling_death_mean
  FROM [Learning_SQL].[dbo].['owid-covid-data$']
  order by location, date
 
 --Remove the 'Upper middle income' rows in location columns 
  Delete FROM [Learning_SQL].[dbo].['owid-covid-data$']
	where location = 'Upper middle income'

	